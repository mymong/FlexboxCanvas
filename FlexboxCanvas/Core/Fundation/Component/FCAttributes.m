//
//  FCAttributes.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import "FCAttributes.h"
#import "FCComponentParent.h"
#import "FCCanvas.h"
#import "FCVariableString.h"
#import "FCVariableDataSource.h"
#import "FCVariableListener.h"

@interface FCAttributes () <FCVariableDataSource, FCVariableListener>
@property (nonatomic, readonly, weak) id<FCComponentParent> component;
@property (nonatomic, nullable) NSDictionary<NSString *, FCVariableString *> *format;
@property (nonatomic, nullable) NSMutableSet<NSString *> *dirtyVariableNames;
@property (nonatomic, nullable) NSMutableDictionary<NSString *, NSString *> *variableValueCache;
@end

@implementation FCAttributes

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
        if (_dirtyVariableNames.count > 0 || _variableValueCache.count > 0) {
            [canvas removeVariableListener:self];
        }
    }
    
    NSMutableSet *variableNames = nil;
    if (format) {
        variableNames = [NSMutableSet new];
        [format enumerateKeysAndObjectsUsingBlock:^(NSString *key, FCVariableString *obj, BOOL *stop) {
            if (obj.names) {
                [variableNames addObjectsFromArray:obj.names];
            }
        }];
        if (0 == variableNames.count) {
            variableNames = nil;
        }
    }
    
    if (variableNames) {
        _dirtyVariableNames = variableNames;
        if (!_variableValueCache) {
            _variableValueCache = [NSMutableDictionary new];
        }
        if (canvas) {
            [canvas addVariableListener:self forNames:variableNames.allObjects];
        }
    }
    else {
        _dirtyVariableNames = nil;
        _variableValueCache = nil;
    }
    
    _format = format;
}

- (void)reload:(NSDictionary *)dictionary {
    NSMutableDictionary *format = nil;
    if (dictionary && dictionary.count) {
        format = [NSMutableDictionary new];
        [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
            FCVariableString *variableString = [FCVariableString variableStringWithString:obj];
            format[key] = variableString;
        }];
        if (0 == format.count) {
            format = nil;
        }
    }
    [self setFormat:format];
}

- (NSMutableDictionary<NSString *, NSString *> *)dictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (_format) {
        if (_dirtyVariableNames) {
            id<FCCanvas> canvas = [_component canvas];
            if (canvas) {
                for (NSString *name in _dirtyVariableNames) {
                    NSString *value = [canvas variableValueForName:name];
                    [_variableValueCache setObject:value forKey:name];
                }
                _dirtyVariableNames = nil;
            }
        }
        [_format enumerateKeysAndObjectsUsingBlock:^(NSString *key, FCVariableString *obj, BOOL *stop) {
            dictionary[key] = [obj stringWithDataSource:self];
        }];
    }
    return dictionary;
}

- (BOOL)isDirty {
    return _dirtyVariableNames.count > 0;
}

#pragma mark <FCVariableDataSource>

- (NSString *)variableValueForName:(NSString *)name {
    return [_variableValueCache objectForKey:name];
}

#pragma mark <FCVariableListener>

- (void)onChangeVariableForName:(NSString *)name {
    NSParameterAssert(name);
    if (name) {
        if (!_dirtyVariableNames) {
            _dirtyVariableNames = [NSMutableSet new];
        }
        [_dirtyVariableNames addObject:name];
        [_component notifyWaitingDirty];
    }
}

@end
