//
//  FCComponentVariables.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import "FCComponentVariables.h"
#import "FCComponentParent.h"
#import "FCCanvas.h"
#import "FCVariableString.h"
#import "FCVariableDataSource.h"
#import "FCVariableListener.h"

@interface FCComponentVariables () <FCVariableDataSource, FCVariableListener>
@property (nonatomic, readonly, weak) id<FCComponentParent> component;
@property (nonatomic, nullable) NSDictionary<NSString *, FCVariableString *> *format;
@property (nonatomic, nullable) NSMutableSet<NSString *> *dirtyNames;
@property (nonatomic, nullable) NSMutableDictionary<NSString *, NSString *> *valueCache;
@end

@implementation FCComponentVariables

- (instancetype)initWithComponent:(id<FCComponentParent>)component {
    NSParameterAssert(component);
    if (self = [super init]) {
        _component = component;
    }
    return self;
}

- (void)setFormat:(NSDictionary<NSString *, FCVariableString *> *)format {
    if (_format == format) {
        return;
    }
    
    id<FCCanvas> canvas = [self.component canvas];
    if (canvas) {
        if (_dirtyNames || _valueCache) {
            [canvas removeVariableListener:self];
        }
    }
    
    NSMutableSet *names = nil;
    if (format) {
        names = [NSMutableSet new];
        [format enumerateKeysAndObjectsUsingBlock:^(NSString *key, FCVariableString *obj, BOOL *stop) {
            if (obj.names) {
                [names addObjectsFromArray:obj.names];
            }
        }];
        if (0 == names.count) {
            names = nil;
        }
    }
    
    if (names) {
        _dirtyNames = names;
        if (!_valueCache) {
            _valueCache = [NSMutableDictionary new];
        }
        if (canvas) {
            [canvas addVariableListener:self forNames:names.allObjects];
        }
    }
    else {
        _dirtyNames = nil;
        _valueCache = nil;
    }
    
    _format = format;
}

- (void)reload:(NSDictionary *)dictionary {
    NSMutableDictionary *format = nil;
    if (dictionary && dictionary.count > 0) {
        format = [NSMutableDictionary new];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            FCVariableString *variableString = [FCVariableString variableStringWithString:obj];
            format[key] = variableString;
        }];
    }
    [self setFormat:format];
}

- (NSDictionary<NSString *, NSString *> *)dictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (_format) {
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
        [_format enumerateKeysAndObjectsUsingBlock:^(NSString *key, FCVariableString *obj, BOOL *stop) {
            dictionary[key] = [obj stringWithDataSource:self];
        }];
    }
    return dictionary;
}

- (NSDictionary<NSString *, NSString *> *)changes {
    NSMutableDictionary *dict = [NSMutableDictionary new];
    if (_format && _dirtyNames) {
        id<FCCanvas> canvas = [_component canvas];
        if (canvas) {
            for (NSString *name in _dirtyNames) {
                NSString *value = [canvas variableValueForName:name];
                [_valueCache setObject:value forKey:name];
            }
            [_format enumerateKeysAndObjectsUsingBlock:^(NSString *key, FCVariableString *obj, BOOL *stop) {
                if (obj.names) {
                    for (NSString *name in obj.names) {
                        if ([_dirtyNames containsObject:name]) {
                            dict[key] = [obj stringWithDataSource:self];
                        }
                    }
                }
            }];
            _dirtyNames = nil;
        }
    }
    return dict;
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
