//
//  FCElementBuilder_TBXML_1_5.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/23.
//

#import "FCElementBuilder_TBXML_1_5.h"
#import "FCElement.h"
#import <TBXML/TBXML.h>
#import "FCLog.h"

@interface TBXML (ExportError)
+ (NSError *)errorWithCode:(int)code userInfo:(NSDictionary *)someUserInfo;
@end

@implementation FCElementBuilder_TBXML_1_5

+ (void)load {
    [FCElementBuilder registerBuilder:[self new]];
}

- (nullable FCElement *)elementWithXMLData:(NSData *)data {
    NSError *error;
    TBXML *xml = [[TBXML alloc] initWithXMLData:data error:&error];
    if (!xml) {
        FCLog(@"Failed to parse xml data, error: %@", error);
        return nil;
    }
    return [self elementWithXMLDocument:xml];
}

- (nullable FCElement *)elementWithXMLString:(NSString *)string {
    NSError *error;
    TBXML *xml = [[TBXML alloc] initWithXMLString:string error:&error];
    if (!xml) {
        FCLog(@"Failed to parse xml with string: %@, error: %@", string, error);
        return nil;
    }
    return [self elementWithXMLDocument:xml];
}

#pragma mark Private

- (FCElement *)elementWithXMLDocument:(TBXML *)xml {
    TBXMLElement *node = [xml rootXMLElement];
    return [self elementWithXMLNode:node defaultKey:@"!Root"];
}

- (FCElement *)elementWithXMLNode:(TBXMLElement *)node defaultKey:(NSString *)defaultKey {
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
