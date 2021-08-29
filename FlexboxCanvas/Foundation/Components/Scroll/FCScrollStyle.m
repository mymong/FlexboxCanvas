//
//  FCScrollStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/26.
//

#import "FCScrollStyle.h"
#import "NSArray+FCEnumValue.h"

@implementation FCScrollStyle {
    BOOL _clipToBounds;
}

- (void)reset {
    [super reset];
    self.styleRef->overflow = FC_Overflow_Scroll;
    _clipToBounds = YES;
}

- (BOOL)clipToBounds {
    return _clipToBounds;
}

- (void)set_overflow:(NSString *)str {
    FC_Overflow overflow = (FC_Overflow)[self.enumStrsOverflow fc_enumValueForStr:str defaultValue:FC_Overflow_Hidden];
    _clipToBounds = (overflow != FC_Overflow_Visible);
}

@end
