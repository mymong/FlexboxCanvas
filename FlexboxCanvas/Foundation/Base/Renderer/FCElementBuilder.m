//
//  FCElementBuilder.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/23.
//

#import "FCElementBuilder.h"

static id<FCElementBuilder> g_FC_ElementBuilder;

@implementation FCElementBuilder

+ (id<FCElementBuilder>)builder {
    return g_FC_ElementBuilder;
}

+ (void)registerBuilder:(id<FCElementBuilder>)builder {
    g_FC_ElementBuilder = builder;
}

@end
