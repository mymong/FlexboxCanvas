//
//  FCLayoutNode.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import "FCLayoutNode.h"

@implementation FCLayoutNode

static Class g_FCLayoutNode_class;

+ (id<FCLayoutNode>)node {
    return [g_FCLayoutNode_class new];
}

+ (void)registerClass:(Class)clazz {
    g_FCLayoutNode_class = clazz;
}

static BOOL g_FCLayoutNode_isRTL = NO;

+ (BOOL)isRTL {
    return g_FCLayoutNode_isRTL;
}

+ (void)setIsRTL:(BOOL)isRTL {
    g_FCLayoutNode_isRTL = isRTL;
}

@end
