//
//  FCBoxProps.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCBoxProps.h"

@implementation FCBoxProps

- (Class)styleClass {
    return [FCBoxStyle class];
}

- (void)reset {
    [super reset];
    _style = [[self styleClass] new];
}

- (void)set_style:(NSString *)str {
    [_style reset];
    if (str && str.length > 0) {
        [_style setFromString:str];
    }
}

@end
