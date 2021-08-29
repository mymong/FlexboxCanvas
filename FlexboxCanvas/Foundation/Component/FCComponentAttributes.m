//
//  FCComponentAttributes.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import "FCComponentAttributes.h"
#import "FCComponentParent.h"
#import "FCCanvas.h"
#import "FCVariableDictionary.h"
#import "FCVariableListener.h"

@interface FCComponentAttributes () <FCVariableDataSource, FCVariableListener>
@property (nonatomic, readonly, weak) id<FCComponentParent> component;
@property (nonatomic, nullable) FCVariableDictionary *variableDictionary;
@property (nonatomic, nullable) NSMutableSet<NSString *> *dirtyNames;
@property (nonatomic, nullable) NSMutableDictionary<NSString *, NSString *> *valueCache;
@end

@implementation FCComponentAttributes

- (instancetype)initWithComponent:(id<FCComponentParent>)component {
    NSParameterAssert(component);
    if (self = [super init]) {
        _component = component;
    }
    return self;
}

- (void)reload:(FCVariableDictionary *)variableDictionary {
    if (_variableDictionary == variableDictionary) {
        return;
    }
    
    id<FCCanvas> canvas = [self.component canvas];
    if (canvas) {
        if (_dirtyNames || _valueCache) {
            [canvas removeVariableListener:self];
        }
    }
    
    NSArray<NSString *> *names = variableDictionary.names;
    if (names && names.count > 0) {
        _dirtyNames = [NSMutableSet setWithArray:names];
        if (!_valueCache) {
            _valueCache = [NSMutableDictionary new];
        }
        if (canvas) {
            [canvas addVariableListener:self forNames:names];
        }
    }
    else {
        _dirtyNames = nil;
        _valueCache = nil;
    }
    
    _variableDictionary = variableDictionary;
}

- (NSDictionary<NSString *, NSString *> *)dictionary {
    if (!self.variableDictionary) {
        return @{};
    }
    if (_dirtyNames) {
        id<FCCanvas> canvas = [_component canvas];
        if (canvas) {
            for (NSString *name in _dirtyNames) {
                NSString *value = [canvas variableValueForName:name];
                [_valueCache setObject:value forKey:name];
            }
            _dirtyNames = nil;
        }
    }
    return [self.variableDictionary dictionaryWithDataSource:self];
}

- (BOOL)isDirty {
    return _dirtyNames.count > 0;
}

#pragma mark <FCVariableDataSource>

- (NSString *)variableValueForName:(NSString *)name {
    return [_valueCache objectForKey:name];
}

#pragma mark <FCVariableListener>

- (void)onChangeVariableForName:(NSString *)name {
    if (name) {
        if (!_dirtyNames) {
            _dirtyNames = [NSMutableSet new];
        }
        [_dirtyNames addObject:name];
        [_component notifyWaitingDirty];
    }
}

@end
