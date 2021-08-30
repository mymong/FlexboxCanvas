//
//  FCComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import "FCComponent.h"
#import "FCCanvas.h"
#import "FCElement.h"
#import "FCComponentParams.h"
#import "FCComponentAttributes.h"

@interface FCComponent ()
@property (nonatomic, readonly) FCComponentAttributes *attributes;
@property (nonatomic, nullable, weak) id<FCCanvas> canvas;
@property (nonatomic) BOOL isWaitingDirty;
@property (nonatomic) BOOL isPendingDirty;
@property (nonatomic, nullable) FCElement *waitingElement;
@property (nonatomic, nullable) NSDictionary *renderAttributes;
@property (nonatomic, nullable) NSArray<FCComponent *> *children;
@property (nonatomic, nullable) NSArray<FCComponent *> *removeds;
@end

@implementation FCComponent

+ (FCComponent *)componentWithElement:(FCElement *)element {
    NSParameterAssert(element);
    if (!element) {
        return nil;
    }
    
    Class clazz = NSClassFromString([NSString stringWithFormat:@"FC%@Component", element.name]);
    NSParameterAssert(clazz);
    if (!clazz) {
        return nil;
    }
    
    NSParameterAssert([clazz isSubclassOfClass:FCComponent.class]);
    if (![clazz isSubclassOfClass:FCComponent.class]) {
        return nil;
    }
    
    return [[clazz alloc] initWithElement:element];
}

#pragma mark props

- (Class)propsClass {
    return [FCComponentParams class];
}

#pragma mark element

- (instancetype)initWithElement:(FCElement *)element {
    NSParameterAssert(element);
    if (!element) {
        return nil;
    }
    
#ifdef DEBUG
    NSString *className = [NSString stringWithFormat:@"FC%@Component", element.name];
    NSParameterAssert([NSStringFromClass(self.class) isEqualToString:className]);
#endif
    
    if (self = [super init]) {
        _name = element.name;
        _key = element.key;
        _props = [[self propsClass] new];
        _attributes = [[FCComponentAttributes alloc] initWithComponent:self];
        [self setWaitingElement:element];
    }
    return self;
}

- (void)reload:(FCElement *)element {
    NSParameterAssert(element);
    if (element) {
        [self setWaitingElement:element];
    }
}

- (void)setWaitingElement:(FCElement *)element {
    NSParameterAssert(element);
    if (_waitingElement != element) {
        _waitingElement = element;
        [self notifyWaitingDirty];
    }
}

#pragma mark parent

- (void)moveToParent:(id<FCComponentParent>)parent {
    NSParameterAssert(parent);
    if (_parent != parent) {
        _parent = parent;
        _canvas = [parent canvas];
        _isPendingDirty = YES;
    }
}

- (void)removeFromParent {
    if (_parent) {
        _parent = nil;
    }
    if (_canvas) {
        _canvas = nil;
    }
    
    if (_children) {
        for (FCComponent *child in _children) {
            [child removeFromParent];
        }
        _children = nil;
    }
    
    if (_removeds) {
        for (FCComponent *child in _removeds) {
            [child removeFromParent];
        }
        _removeds = nil;
    }
}

#pragma mark children

- (void)setChildren:(nullable NSArray<FCComponent *> *)children {
    if (_children != children) {
        if (children) {
            for (FCComponent *child in children) {
                [child moveToParent:self];
            }
        }
        _children = children;
    }
}

- (void)rebuildChildComponents:(nullable NSArray<FCElement *> *)elements {
    NSMutableDictionary *reusePool = [NSMutableDictionary new];
    if (_children) {
        for (FCComponent *child in _children) {
            reusePool[child.key] = child;
        }
    }
    
    NSMutableArray *children = nil;
    if (elements) {
        children = [NSMutableArray new];
        for (FCElement *element in elements) {
            FCComponent *component = reusePool[element.key];
            if (component && [component.name isEqualToString:element.name]) {
                [component reload:element];
                [children addObject:component];
                [reusePool removeObjectForKey:element.key];
            }
            else {
                component = [FCComponent componentWithElement:element];
                if (component) {
                    [children addObject:component];
                }
            }
        }
        if (0 == children.count) {
            children = nil;
        }
    }
    
    _removeds = reusePool.allValues;
    
    [self setChildren:children];
}

#pragma mark node

- (void)configNodeTree {
    // To be overriden
}

#pragma mark frame

- (void)decideChildFrames {
    // To be overriden
}

#pragma mark managed view

- (void)buildManagedView {
    // To be overriden
}

- (void)moveManagedView {
    // To be overriden
}

- (void)finishManagedView {
    // To be overriden
}

- (BOOL)isTouchable {
    BOOL touchable = NO;
    if (_children) {
        for (FCComponent *child in _children) {
            if ([child isTouchable]) {
                touchable = YES;
                break;
            }
        }
    }
    return touchable;
}

#pragma mark event

- (void)sendEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender {
    NSParameterAssert(event && message);
    if (event && message) {
        id<FCCanvas> canvas = [self canvas];
        if (canvas) {
            [canvas onEvent:event message:message userInfo:userInfo sender:sender];
        }
    }
}

#pragma mark <FCComponentLayout>

- (id<FCLayoutNode>)node {
    // To be overriden.
    return nil;
}

- (CGRect)frame {
    // To be overriden.
    return CGRectZero;
}

- (void)setFrame:(CGRect)frame {
    // To be overriden.
}

#pragma mark <FCComponentParent>

- (UIView *)view {
    if (_parent) {
        return [_parent view];
    }
    return nil;
}

- (id<FCCanvas>)canvas {
    if (_canvas) {
        return _canvas;
    }
    if (_parent) {
        return [_parent canvas];
    }
    return nil;
}

- (void)notifyWaitingDirty {
    if (!_isWaitingDirty) {
        _isWaitingDirty = YES;
        if (_parent) {
            [_parent notifyWaitingDirty];
        }
    }
}

- (void)notifyPendingDirty {
    if (!_isPendingDirty) {
        _isPendingDirty = YES;
        if (_parent) {
            [_parent notifyPendingDirty];
        }
    }
}

#pragma mark <FCComponentRendering>

- (void)startComponentRender {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isWaitingDirty) {
        _isWaitingDirty = NO;
        _isPendingDirty = YES;
        
        if (_waitingElement) {
            _key = _waitingElement.key;
            [_attributes reload:_waitingElement.attributes];
            _renderAttributes = [_attributes dictionary];
            [self rebuildChildComponents:_waitingElement.children];
            _waitingElement = nil;
        } else if (_attributes.isDirty) {
            _renderAttributes = [_attributes dictionary];
        } else {
            _renderAttributes = nil;
        }
        
        if (_children) {
            for (FCComponent *child in _children) {
                [child startComponentRender];
            }
        }
    }
}

- (void)startComponentLayout {
    if (_renderAttributes) {
        [_props reset];
        [_props setFromDictionary:_renderAttributes];
        
        [self configNodeTree];
    }
    
    if (_children) {
        for (FCComponent *child in _children) {
            [child startComponentLayout];
        }
    }
}

- (void)finishComponentLayout {
    [self decideChildFrames];
    
    if (_children) {
        for (FCComponent *child in _children) {
            [child finishComponentLayout];
        }
    }
}

- (void)finishComponentRender {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isPendingDirty) {
        if (_renderAttributes) {
            [self buildManagedView];
        } else {
            [self moveManagedView];
        }
        
        if (_children) {
            for (FCComponent *child in _children) {
                [child finishComponentRender];
            }
        }
        
        if (_removeds) {
            for (FCComponent *child in _removeds) {
                [child removeFromParent];
            }
            _removeds = nil;
        }
        
        [self finishManagedView];
        
        _renderAttributes = nil;
        _isPendingDirty = NO;
    }
}

@end
