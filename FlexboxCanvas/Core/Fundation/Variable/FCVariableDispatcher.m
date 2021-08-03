//
//  FCVariableDispatcher.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import "FCVariableDispatcher.h"
#import "FCVariableListener.h"

@interface FCVariableDispatcher ()
@property (nonatomic, readonly) NSMutableDictionary<NSString *, NSPointerArray *> *map;
@end

@implementation FCVariableDispatcher

- (instancetype)init {
    if (self = [super init]) {
        _map = [NSMutableDictionary new];
    }
    return self;
}

- (void)addListener:(id<FCVariableListener>)listener forName:(NSString *)name {
    void *pointer = (__bridge void *)listener;
    NSParameterAssert(pointer);
    if (!pointer) {
        return;
    }
    NSPointerArray *array = self.map[name];
    if (!array) {
        array = [NSPointerArray weakObjectsPointerArray];
        [self.map setObject:array forKey:name];
        if (self.delegate) {
            [self.delegate willBeginVariableListeningForName:name];
        }
    }
    [array addPointer:pointer];
}

- (void)removeListener:(id<FCVariableListener>)listener {
    void *pointer = (__bridge void *)listener;
    NSParameterAssert(pointer);
    if (!pointer) {
        return;
    }
    NSMutableArray *names = [NSMutableArray new];
    [self.map enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSPointerArray *obj, BOOL *stop) {
        for (NSInteger i = 0; i < obj.count; i ++) {
            if ([obj pointerAtIndex:i] == pointer) {
                [obj removePointerAtIndex:i];
                [names addObject:key];
                break;
            }
        }
    }];
    for (NSString *name in names) {
        NSPointerArray *array = self.map[name];
        if (array && array.allObjects.count == 0) {
            [self.map removeObjectForKey:name];
            if (self.delegate) {
                [self.delegate didEndVariableListeningForName:name];
            }
        }
    }
}

- (void)removeAllListeners {
    NSArray *names = self.map.allKeys;
    if (names.count > 0) {
        [self.map removeAllObjects];
        if (self.delegate) {
            for (NSString *name in names) {
                [self.delegate didEndVariableListeningForName:name];
            }
        }
    }
}

- (void)dispatchChangeForName:(NSString *)name {
    NSParameterAssert([name isKindOfClass:NSString.class]);
    if (!name || 0 == name.length) {
        return;
    }
    NSPointerArray *array = self.map[name];
    if (!array) {
        return;
    }
    NSArray *listeners = array.allObjects;
    if (listeners.count > 0) {
        for (id<FCVariableListener> listener in listeners) {
            [listener onChangeVariableForName:name];
        }
    }
    else {
        [self.map removeObjectForKey:name];
        if (self.delegate) {
            [self.delegate didEndVariableListeningForName:name];
        }
    }
}

@end
