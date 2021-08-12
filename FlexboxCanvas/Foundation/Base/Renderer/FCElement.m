//
//  FCElement.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import "FCElement.h"
#import <TBXML/TBXML.h>
#import "FCLog.h"

@interface TBXML (ExportError)
+ (NSError *)errorWithCode:(int)code userInfo:(NSDictionary *)someUserInfo;
@end

@implementation FCElement

- (instancetype)initWithName:(NSString *)name attributes:(NSDictionary *)attributes children:(NSArray *)children defaultKey:(NSString *)defaultKey {
    NSParameterAssert(name);
    if (self = [super init]) {
        _name = name;
        _attributes = attributes;
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

@end

@implementation FCElement (FCElementFactory)

+ (FCElement *)elementWithXMLString:(NSString *)string {
    NSError *error;
    TBXML *xml = [[TBXML alloc] initWithXMLString:string error:&error];
    if (!xml) {
        FCLog(@"Failed to parse xml with string: %@, error: %@", string, error);
        return nil;
    }
    return [self elementWithXMLDocument:xml];
}

+ (FCElement *)elementWithXMLResource:(NSString *)name inBundle:(NSBundle *)bundle {
    if (!bundle) {
        bundle = [NSBundle mainBundle];
    }
    NSString *path = [bundle pathForResource:name ofType:nil];
    if (!path) {
        FCLog(@"Can not find xml resource with name: %@", name);
        return nil;
    }
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSError *error;
    TBXML *xml = [[TBXML alloc] initWithXMLData:data error:&error];
    if (!xml) {
        FCLog(@"Failed to parse xml with path: %@, error: %@", path, error);
        return nil;
    }
    return [self elementWithXMLDocument:xml];
}

#pragma mark Private

+ (FCElement *)elementWithXMLDocument:(TBXML *)xml {
    TBXMLElement *node = [xml rootXMLElement];
    return [self elementWithXMLNode:node defaultKey:@"!Root"];
}

+ (FCElement *)elementWithXMLNode:(TBXMLElement *)node defaultKey:(NSString *)defaultKey {
    NSParameterAssert(node);
    if (!node) {
        return nil;
    }
    
    NSString *name = [NSString stringWithCString:node->name encoding:NSUTF8StringEncoding];
    NSParameterAssert(name && name.length);
    
    NSMutableDictionary<NSString *, NSString *> *attributes = [NSMutableDictionary new];
    TBXMLAttribute *attr = node->firstAttribute;
    while (attr) {
        NSString *name = [NSString stringWithCString:attr->name encoding:NSUTF8StringEncoding];
        NSString *value = [NSString stringWithCString:attr->value encoding:NSUTF8StringEncoding];
        if (name && name.length && value) {
            attributes[name] = value;
        }
        attr = attr->next;
    }
    
    NSMutableArray<FCElement *> *children = [NSMutableArray new];
    NSMutableDictionary *countsByNames = [NSMutableDictionary new];
    TBXMLElement *subnode = node->firstChild;
    while (subnode) {
        NSString *name = [NSString stringWithCString:subnode->name encoding:NSUTF8StringEncoding];
        NSNumber *count = countsByNames[name] ?: @(0);
        countsByNames[name] = @(count.integerValue + 1);
        NSString *key = [NSString stringWithFormat:@"!%@#%@", name, count];
        
        FCElement *element = [self elementWithXMLNode:subnode defaultKey:key];
        [children addObject:element];
        
        subnode = subnode->nextSibling;
    }
    
    return [[FCElement alloc] initWithName:name attributes:attributes children:children defaultKey:defaultKey];
}

@end
