//
//  NSDictionary+FCValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (FCValue)
- (BOOL)fc_boolValueForKey:(NSString *)key compare:(nullable NSString *)yes;
- (float)fc_floatValueForKey:(NSString *)key defaultValue:(float)def;
- (CGSize)fc_sizeValueForKey:(NSString *)key defaultValue:(CGSize)def;
- (CGPoint)fc_pointValueForKey:(NSString *)key defaultValue:(CGPoint)def;
- (UIEdgeInsets)fc_edgeValueForKey:(NSString *)key defaultValue:(UIEdgeInsets)def;
- (nullable UIColor *)fc_colorValueForKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
