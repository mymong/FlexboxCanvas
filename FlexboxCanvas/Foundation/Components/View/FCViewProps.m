//
//  FCViewProps.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCViewProps.h"
#import "FCViewStyle.h"

@implementation FCViewProps

- (Class)styleClass {
    return [FCViewStyle class];
}

- (void)set_nativeView:(NSString *)str {
    _nativeView = str;
}

- (void)set_touchableOpacity:(NSString *)str {
    _touchableOpacity = [str boolValue];
}

- (void)set_onRef:(NSString *)str {
    _onRef = str;
}

- (void)set_onPress:(NSString *)str {
    _onPress = str;
}

- (void)set_onLongPress:(NSString *)str {
    _onLongPress = str;
}

@end
