//
//  FCComponentParams.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCComponentParams.h"

@implementation FCComponentParams

- (instancetype)init {
    if (self = [super init]) {
        [self reset];
    }
    return self;
}

- (void)reset {
    
}

- (NSInteger)maxConnectorLevel {
    return 1;
}

- (NSDictionary *)setFromDictionary:(NSDictionary *)dictionary {
    NSString *connector = @"";
    NSInteger count = [self maxConnectorLevel];
    for (NSInteger i = 0; i < count && dictionary.count > 0; i ++) {
        connector = [connector stringByAppendingString:@"_"];
        dictionary = [self setFromDictionary:dictionary connector:connector];
    }
    return dictionary;
}

- (NSDictionary *)setFromDictionary:(NSDictionary *)dictionary connector:(NSString *)connector {
    NSMutableDictionary *remains = [NSMutableDictionary new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *str, BOOL *stop) {
        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"set%@%@:", connector, key]);
        if ([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:sel withObject:str];
#pragma clang diagnostic pop
        } else {
            [remains setObject:str forKey:key];
        }
    }];
    return remains;
}

@end
