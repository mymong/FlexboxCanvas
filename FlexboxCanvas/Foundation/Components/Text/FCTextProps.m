//
//  FCTextProps.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCTextProps.h"
#import "FCTextStyle.h"

@implementation FCTextProps

- (Class)styleClass {
    return [FCTextStyle class];
}

- (void)set_text:(NSString *)str {
    _text = str;
}

- (void)set_link:(NSString *)str {
    _link = str;
}

@end
