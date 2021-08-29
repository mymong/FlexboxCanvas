//
//  FCVariableDictionary.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/28.
//

#import "FCVariableDictionary.h"

@interface FCVariableDictionary ()
@property (nonatomic, nullable) NSDictionary<NSString *, FCVariableString *> *format;
@end

@implementation FCVariableDictionary

- (instancetype)initWithFormat:(NSDictionary<NSString *, FCVariableString *> *)format names:(nullable NSArray<NSString *> *)names {
    if (self = [super init]) {
        _format = format ?: @{};
        _names = names;
    }
    return self;
}

+ (instancetype)variableDictionaryWithDictionary:(NSDictionary *)dictionary {
    if (!dictionary) {
        return nil;
    }
    
    if (0 == dictionary.count) {
        return [[self alloc] initWithFormat:dictionary names:nil];
    }
    
    NSMutableDictionary *format = [NSMutableDictionary new];
    NSMutableSet *nameSet = [NSMutableSet new];
    [dictionary enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL *stop) {
        FCVariableString *variableString = [FCVariableString variableStringWithString:obj];
        if (variableString) {
            format[key] = variableString;
            if (variableString.names) {
                [nameSet addObjectsFromArray:variableString.names];
            }
        }
    }];
    
    NSArray *names = nameSet.allObjects;
    if (0 == names.count) {
        names = nil;
    }
    
    return [[self alloc] initWithFormat:format names:names];
}

- (NSDictionary *)dictionaryWithDataSource:(id<FCVariableDataSource>)dataSource {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    if (_format) {
        [_format enumerateKeysAndObjectsUsingBlock:^(NSString *key, FCVariableString *obj, BOOL *stop) {
            dictionary[key] = [obj stringWithDataSource:dataSource];
        }];
    }
    return dictionary;
}

@end
