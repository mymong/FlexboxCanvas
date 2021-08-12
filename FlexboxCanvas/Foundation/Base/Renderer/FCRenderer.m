//
//  FCRenderer.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/26.
//

#import "FCRenderer.h"
#import "FCElement.h"
#import "FCComponent.h"
#import "FC_Node.h"

#define FCNullObj ((id)[NSNull null])

@interface FCRenderer () <FCComponentParent, FCComponentHierachy>
@property (nonatomic, weak) UIView *view;
@property (nonatomic) CGSize size;
@property (nonatomic, nullable) FCElement *waitingElement;
@property (nonatomic) BOOL isWaitingDirty;
@property (nonatomic) BOOL isPendingDirty;
@property (nonatomic, nullable) FCComponent *root;
@property (nonatomic, nullable) FCComponent *removed;
@end

@implementation FCRenderer

- (instancetype)initWithView:(UIView *)view {
    if (self = [super init]) {
        _view = view;
        _size = CGSizeZero;
    }
    return self;
}

- (void)loadWithElement:(FCElement *)element {
    if (!element) {
        element = FCNullObj;
    }
    
    if ([NSThread isMainThread]) {
        [self setWaitingElement:element];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setWaitingElement:element];
        });
    }
}

- (void)render {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isPendingDirty) {
        return;
    }
    
    CGSize size = CGSizeZero;
    if (_view) {
        size = _view.bounds.size;
    }
    
    if (!CGSizeEqualToSize(_size, size)) {
        _size = size;
        _isWaitingDirty = YES;
    }
    
    if (!_isWaitingDirty) {
        return;
    }
    
    NSDate *date = [NSDate date];
    [self startComponentHierachy];
    float buildCost = [[NSDate date] timeIntervalSinceDate:date];
    dispatch_async([self calculationQueue], ^{
        [self startLayoutHierachy];
        [self calculateLayout:size];
        if ([self secondLayoutHierachy]) {
            [self calculateLayout:size];
        }
        [self finishLayoutHierachy];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self finishComponentHierachy];
            
            NSTimeInterval cost = [[NSDate date] timeIntervalSinceDate:date];
            NSLog(@"build  cost %@", @(buildCost));
            NSLog(@"render cost %@", @(cost));
            float fps = 1.0 / cost;
            NSLog(@"Flexbox Canvas render fps %@", @(fps));
            
            [self render];
        });
    });
}

#pragma mark Private

- (dispatch_queue_t)calculationQueue {
    static dispatch_queue_t calculationQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calculationQueue = dispatch_queue_create("flexboxcanvas.calculation", DISPATCH_QUEUE_SERIAL);
    });
    return calculationQueue;
}

- (void)setWaitingElement:(FCElement *)element {
    NSParameterAssert(element);
    if (_waitingElement != element) {
        _waitingElement = element;
        [self notifyWaitingDirty];
    }
}

- (void)rebuildComponent:(FCElement *)element {
    if (!element || FCNullObj == element) {
        _removed = _root;
    } else if (_root && [_root.name isEqualToString:element.name]) {
        [_root reloadElement:element];
    } else {
        _removed = _root;
        _root = [FCComponent componentWithElement:element];
        [_root moveToParent:self];
    }
}

#pragma mark <FCComponentParent>

- (UIView *)view {
    return _view;
}

- (id<FCCanvas>)canvas {
    return _canvas;
}

- (void)notifyWaitingDirty {
    if (!_isWaitingDirty) {
        _isWaitingDirty = YES;
        if (_view) {
            [_view setNeedsLayout];
        }
    }
}

- (void)notifyPendingDirty {
    if (!_isPendingDirty) {
        _isPendingDirty = YES;
    }
}

#pragma mark <FCComponentHierachy>

- (void)startComponentHierachy {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isWaitingDirty) {
        _isWaitingDirty = NO;
        _isPendingDirty = YES;
        
        //重建
        if (_waitingElement) {
            [self rebuildComponent:_waitingElement];
            _waitingElement = nil;
        }
        
        //递归
        if (_root) {
            [_root startComponentHierachy];
        }
    }
}

- (void)startLayoutHierachy {
    if (_root) {
        [_root startLayoutHierachy];
    }
}

- (void)calculateLayout:(CGSize)size {
    if (_root) {
        [_root.node calculateInSize:size];
    }
}

- (NSUInteger)secondLayoutHierachy {
    if (_root) {
        return [_root secondLayoutHierachy];
    }
    return 0;
}

- (void)finishLayoutHierachy {
    if (_root) {
        _root.frame = _root.node.frame;
        [_root finishLayoutHierachy];
    }
}

- (void)finishComponentHierachy {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isPendingDirty) {
        //递归结束所有子组件
        if (_root) {
            [_root finishComponentHierachy];
        }
        
        //释放移除的子组件
        if (_removed) {
            [_removed removeFromParent];
            _removed = nil;
        }
        
        //完成当前组件的渲染
        _isPendingDirty = NO;
    }
}

@end
