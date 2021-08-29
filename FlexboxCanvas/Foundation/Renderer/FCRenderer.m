//
//  FCRenderer.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/26.
//

#import "FCRenderer.h"
#import "FCElement.h"
#import "FCComponent.h"
#import "FCLayoutNode.h"

#define FCEmptyElement ((id)[NSNull null])

@interface FCRenderer () <FCComponentParent, FCComponentRendering>
@property (nonatomic, weak) UIView *view;
@property (nonatomic) CGSize size;
@property (nonatomic) BOOL isWaitingDirty;
@property (nonatomic) BOOL isPendingDirty;
@property (nonatomic, nullable) FCElement *waitingElement;
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

- (void)reload:(FCElement *)element {
    if (!element) {
        element = FCEmptyElement;
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
    
    [self startComponentRender];
    dispatch_async([self calculationQueue], ^{
        [self startComponentLayout];
        [self calculateLayout:size];
        [self finishComponentLayout];
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self finishComponentRender];
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

- (void)rebuildRootComponent:(FCElement *)element {
    if (!element || FCEmptyElement == element) {
        _removed = _root;
        _root = nil;
    } else if (_root && [_root.name isEqualToString:element.name]) {
        [_root reload:element];
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

#pragma mark <FCComponentRendering>

- (void)startComponentRender {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isWaitingDirty) {
        _isWaitingDirty = NO;
        _isPendingDirty = YES;
        
        if (_waitingElement) {
            [self rebuildRootComponent:_waitingElement];
            _waitingElement = nil;
        }
        
        if (_root) {
            [_root startComponentRender];
        }
    }
}

- (void)startComponentLayout {
    if (_root) {
        [_root startComponentLayout];
    }
}

- (void)calculateLayout:(CGSize)size {
    if (_root) {
        [_root.node calculateInSize:size];
    }
}

- (void)finishComponentLayout {
    if (_root) {
        _root.frame = _root.node.frame;
        [_root finishComponentLayout];
    }
}

- (void)finishComponentRender {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isPendingDirty) {
        if (_root) {
            [_root finishComponentRender];
        }
        
        if (_removed) {
            [_removed removeFromParent];
            _removed = nil;
        }
        
        _isPendingDirty = NO;
    }
}

@end
