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
    _style = nil;
}

- (void)set_style:(NSString *)str {
    if (str.length > 0) {
        if (_style) {
            [_style reset];
        } else {
            _style = [[self styleClass] new];
        }
        [_style setFromString:str];
    } else {
        _style = nil;
    }
}

@end
