//
//  FCImageStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/14.
//

#import "FCImageStyle.h"
#import "NSArray+FCEnumValue.h"
#import "UIColor+FCColor.h"

static NSArray<NSString *> *FCEnumStrsContentMode;

void FC_EnumStrs_Setup_ImageStyle(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FCEnumStrsContentMode = @[@"stretch", @"contain", @"cover", @"repeat", @"center", @"top", @"bottom", @"left", @"right", @"topLeft", @"topRight", @"bottomLeft", @"bottomRight"];
    });
}

@implementation FCImageStyle

- (instancetype)init {
    if (self = [super init]) {
        FC_EnumStrs_Setup_ImageStyle();
    }
    return self;
}

- (void)reset {
    [super reset];
    _tintColor = nil;
    _contentMode = UIViewContentModeScaleAspectFill; //cover
}

- (void)set_contentMode:(NSString *)str {
    _contentMode = [FCEnumStrsContentMode fc_enumValueForStr:str defaultValue:UIViewContentModeScaleAspectFill];
}

- (void)set_tintColor:(NSString *)str {
    _tintColor = [UIColor fc_colorWithString:str];
}

@end
