//
//  FCSliderProps.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCSliderProps.h"
#import "FCSliderStyle.h"

@implementation FCSliderProps

- (Class)styleClass {
    return [FCSliderStyle class];
}

- (void)reset {
    [super reset];
    _thumbKey = nil;
}

- (void)set_thumbKey:(NSString *)str {
    _thumbKey = str;
}

- (void)set_tipsKey:(NSString *)str {
    _tipsKey = str;
}

- (void)set_onChange:(NSString *)str {
    _onChange = str;
}

@end
