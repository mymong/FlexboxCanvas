//
//  NSString+FCValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCValue)
- (CGSize)fc_sizeValue;
+ (NSString *)fc_stringFromSizeValue:(CGSize)size;
- (CGPoint)fc_pointValue;
+ (NSString *)fc_stringFromPointValue:(CGPoint)point;
- (NSArray<NSNumber *> *)fc_floatArrayValue;
+ (NSString *)fc_stringFromFloatArrayValue:(NSArray<NSNumber *> *)array;
- (NSArray<UIColor *> *)fc_colorArrayValue;
+ (NSString *)fc_stringFromColorArrayValue:(NSArray<UIColor *> *)array;
@end

NS_ASSUME_NONNULL_END
