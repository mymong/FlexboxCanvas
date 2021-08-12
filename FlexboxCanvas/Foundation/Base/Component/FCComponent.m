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
#import "FCComponentVariables.h"
#import "NSString+FCStyleString.h"

@interface FCComponent ()
@property (nonatomic, readonly) FCComponentVariables *variables;
@property (nonatomic, weak, nullable) id<FCCanvas> canvas;
@property (nonatomic, nullable) FCElement *waitingElement;
@property (nonatomic) BOOL isWaitingDirty;
@property (nonatomic, nullable) NSDictionary *pendingAttrs;
@property (nonatomic) BOOL isPendingDirty;
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
        _variables = [[FCComponentVariables alloc] initWithComponent:self];
        [self setWaitingElement:element];
    }
    return self;
}

- (void)reloadElement:(FCElement *)element {
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

- (void)setChildren:(NSArray<FCComponent *> *)children {
    if (_children != children) {
        if (!_removeds && _children) {
            if (children) {
                NSMutableArray *removeds = [NSMutableArray new];
                for (FCComponent *child in _children) {
                    if (![children containsObject:child]) {
                        [removeds addObject:child];
                    }
                }
                _removeds = removeds;
            } else {
                _removeds = [_children copy];
            }
        }
        
        if (children) {
            for (FCComponent *child in children) {
                [child moveToParent:self];
            }
        }
        
        _children = children;
    }
}

- (void)buildChildren:(NSArray<FCElement *> *)elements {
    //准备组件重用字典
    NSMutableDictionary *pool = [NSMutableDictionary new];
    if (_children) {
        for (FCComponent *child in _children) {
            pool[child.key] = child;
        }
    }
    
    //重用或新建子组件
    NSMutableArray *children = [NSMutableArray new];
    for (FCElement *element in elements) {
        //通过key和name匹配可重用的组件
        FCComponent *component = pool[element.key];
        if (component && [component.name isEqualToString:element.name]) {
            //配置新元素
            [component setWaitingElement:element];
            //添加子组件
            [children addObject:component];
            //从池中移除
            [pool removeObjectForKey:element.key];
        }
        else {
            //新建子组件
            component = [FCComponent componentWithElement:element];
            if (component) {
                //添加子组件
                [children addObject:component];
            }
        }
    }
    
    //需要被移除的组件
    _removeds = pool.allValues;
    
    [self setChildren:children];
}

- (void)parseStyle:(NSMutableDictionary *)props {
    NSString *styleKey = @"style";
    NSString *styleString = props[styleKey];
    if (styleString) {
        NSParameterAssert([styleString isKindOfClass:NSString.class]);
        NSDictionary *styleDictionary = [styleString fc_styleDictionary];
        if (styleDictionary.count > 0) {
            props[styleKey] = styleDictionary;
        } else {
            [props removeObjectForKey:styleKey];
        }
    }
}

- (Class)propsClass {
    return [FCComponentParams class];
}

- (void)startNode {
    // To be overriden
}

- (void)linkSubnodes {
    // To be overriden
}

- (void)finishNode {
    // To be overriden
}

- (void)startManagedView {
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

- (id<FC_Node>)node {
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

#pragma mark <FCComponentHierachy>

- (void)startComponentHierachy {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isWaitingDirty) {
        _isWaitingDirty = NO;
        _isPendingDirty = YES;
        
        if (_waitingElement) {
            _key = _waitingElement.key;
            [_variables reload:_waitingElement.attributes];
            _pendingAttrs = [_variables dictionary];
            [self buildChildren:_waitingElement.children];
            _waitingElement = nil;
        } else if (_variables.isDirty) {
            _pendingAttrs = [_variables dictionary];
        } else {
            _pendingAttrs = nil;
        }
        
        if (_children) {
            for (FCComponent *child in _children) {
                [child startComponentHierachy];
            }
        }
    }
}

- (void)startLayoutHierachy {
    if (_pendingAttrs) {
        [_props reset];
        [_props setFromDictionary:_pendingAttrs];
        
        [self startNode];
        [self linkSubnodes];
    }
    
    if (_children) {
        for (FCComponent *child in _children) {
            [child startLayoutHierachy];
        }
    }
}

- (NSUInteger)secondLayoutHierachy {
    NSUInteger num = 0;
    if (_children) {
        for (FCComponent *child in _children) {
            num += [child secondLayoutHierachy];
        }
    }
    return num;
}

- (void)finishLayoutHierachy {
    [self finishNode];
    
    if (_children) {
        for (FCComponent *child in _children) {
            [child finishLayoutHierachy];
        }
    }
}

- (void)finishComponentHierachy {
    NSParameterAssert([NSThread isMainThread]);
    
    if (_isPendingDirty) {
        if (_pendingAttrs) {
            [self startManagedView];
        } else {
            [self moveManagedView];
        }
        
        if (_children) {
            for (FCComponent *child in _children) {
                [child finishComponentHierachy];
            }
        }
        
        if (_removeds) {
            for (FCComponent *child in _removeds) {
                [child removeFromParent];
            }
            _removeds = nil;
        }
        
        [self finishManagedView];
        
        _pendingAttrs = nil;
        _isPendingDirty = NO;
    }
}

@end
