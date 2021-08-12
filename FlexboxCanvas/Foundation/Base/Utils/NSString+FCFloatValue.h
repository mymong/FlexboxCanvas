//
//  NSString+FCFloatValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCFloatValue)
- (float)fc_floatValueWithDefault:(float)def;
- (float)fc_floatValueWithDefault:(float)def minValue:(float)min;
- (float)fc_floatValueWithDefault:(float)def minValue:(float)min maxValue:(float)max;
- (float)fc_abs_floatValueWithDefault:(float)def;
@end

NS_ASSUME_NONNULL_END
