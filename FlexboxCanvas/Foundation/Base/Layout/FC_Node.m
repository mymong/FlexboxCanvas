//
//  FC_Node.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import "FC_Node.h"

@implementation FC_Node

static Class g_FC_Node_class;

+ (id<FC_Node>)node {
    return [g_FC_Node_class new];
}

+ (void)registerClass:(Class)clazz {
    g_FC_Node_class = clazz;
}

static BOOL g_FC_Node_isRTL = NO;

+ (BOOL)isRTL {
    return g_FC_Node_isRTL;
}

+ (void)setIsRTL:(BOOL)isRTL {
    g_FC_Node_isRTL = isRTL;
}

@end
