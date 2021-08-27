//
//  FCScrollViewProps.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/25.
//

#import "FCScrollViewProps.h"
#import "FCScrollViewStyle.h"

@implementation FCScrollViewProps

- (Class)styleClass {
    return [FCScrollViewStyle class];
}

- (void)reset {
    [super reset];
    _onScroll = nil;
}

- (void)set_onScroll:(NSString *)str {
    _onScroll = str;
}

@end
