//
//  FCScrollViewStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/26.
//

#import "FCScrollViewStyle.h"

@implementation FCScrollViewStyle

- (void)reset {
    [super reset];
    self.styleRef->overflow = FC_Overflow_Scroll;
}

@end
