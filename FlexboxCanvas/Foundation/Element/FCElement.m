//
//  FCElement.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import "FCElement.h"
#import "FCElementBuilder.h"
#import "FCVariableDictionary.h"
#import "FCLog.h"

@implementation FCElement

- (instancetype)initWithName:(NSString *)name attributes:(NSDictionary *)attributes children:(NSArray *)children defaultKey:(NSString *)defaultKey {
    NSParameterAssert(name);
    if (self = [super init]) {
        _name = name;
        _attributes = [FCVariableDictionary variableDictionaryWithDictionary:attributes];
        _children = children;
        _key = defaultKey;
        if (attributes) {
            NSString *customKey = attributes[@"key"];
            if (customKey && customKey.length > 0 && ![customKey hasPrefix:@"!"]) {
                _key = customKey;
            }
        }
    }
    return self;
}

+ (nullable FCElement *)elementWithXMLString:(NSString *)string {
    return [[FCElementBuilder builder] elementWithXMLString:string];
}

+ (nullable FCElement *)elementWithXMLResource:(NSString *)name inBundle:(NSBundle *)bundle {
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    NSString *path = [bundle pathForResource:name ofType:nil];
    if (!path) {
        FCLog(@"Can not find xml resource with name: %@", name);
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    return [[FCElementBuilder builder] elementWithXMLData:data];
}

@end
