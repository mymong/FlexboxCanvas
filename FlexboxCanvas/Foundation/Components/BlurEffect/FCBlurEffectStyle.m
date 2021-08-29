//
//  FCBlurEffect.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/29.
//

#import "FCBlurEffectStyle.h"
#import "NSArray+FCEnumValue.h"
#import "UIColor+FCColor.h"

static NSArray<NSString *> *FCEnumStrsBlurType;

void FC_EnumStrs_Setup_BlurEffectStyle(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FCEnumStrsBlurType = @[@"extraLight", @"light", @"dark"];
    });
}

@implementation FCBlurEffectStyle

- (instancetype)init {
    if (self = [super init]) {
        FC_EnumStrs_Setup_BlurEffectStyle();
    }
    return self;
}

- (void)reset {
    [super reset];
    _blurType = UIBlurEffectStyleLight;
}

- (void)set_blurType:(NSString *)str {
    _blurType = [FCEnumStrsBlurType fc_enumValueForStr:str defaultValue:UIBlurEffectStyleLight];
}

@end
