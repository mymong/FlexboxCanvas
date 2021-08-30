//
//  FCSliderStyle.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCSliderStyle.h"
#import "NSString+FCFloatValue.h"

@implementation FCSliderStyle

- (void)reset {
    [super reset];
    _value = 0;
    _minValue = 0;
    _maxValue = 1;
    _tipsSpace = 8;
}

- (void)set_value:(NSString *)str {
    _value = [str fc_floatValueWithDefault:0];
}

- (void)set_minValue:(NSString *)str {
    _minValue = [str fc_floatValueWithDefault:0];
}

- (void)set_maxValue:(NSString *)str {
    _maxValue = [str fc_floatValueWithDefault:1];
}

- (void)set_tipsSpace:(NSString *)str {
    _tipsSpace = [str fc_floatValueWithDefault:8];
}

@end
