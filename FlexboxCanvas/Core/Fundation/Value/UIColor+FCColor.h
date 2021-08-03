//
//  UIColor+FCColor.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/29.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (FCColor)
- (NSString *)fc_hexString;
- (NSString *)fc_hexStringWithAlpha;
- (NSString *)fc_hexStringWithoutAlpha;
+ (instancetype)fc_colorWithString:(NSString *)string;
@end

NS_ASSUME_NONNULL_END
