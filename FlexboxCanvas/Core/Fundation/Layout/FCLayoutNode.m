//
//  FCLayoutNode.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/23.
//

#import "FCLayoutNode.h"

@implementation FCLayoutNodeFactory

static Class g_layoutNode_class;

+ (void)registerLayoutNodeClass:(Class)clazz {
    g_layoutNode_class = clazz;
}

+ (id<FCLayoutNode>)node {
    return [g_layoutNode_class new];
}

@end
