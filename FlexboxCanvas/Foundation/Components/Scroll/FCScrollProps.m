//
//  FCScrollProps.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/25.
//

#import "FCScrollProps.h"
#import "FCScrollStyle.h"

@implementation FCScrollProps

- (Class)styleClass {
    return [FCScrollStyle class];
}

- (void)reset {
    [super reset];
    _onScroll = nil;
}

- (void)set_onScroll:(NSString *)str {
    _onScroll = str;
}

@end
