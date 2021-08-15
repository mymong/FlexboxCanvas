//
//  FCImageProps.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/14.
//

#import "FCImageProps.h"
#import "FCImageStyle.h"

@implementation FCImageProps

- (Class)styleClass {
    return [FCImageStyle class];
}

- (void)reset {
    [super reset];
    _uri = nil;
}

- (void)set_uri:(NSString *)str {
    _uri = str;
}

@end
