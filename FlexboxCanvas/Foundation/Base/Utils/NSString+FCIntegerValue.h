//
//  NSString+FCIntegerValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCIntegerValue)
- (NSInteger)fc_integerValueWithDefault:(NSInteger)def;
- (NSInteger)fc_integerValueWithDefault:(NSInteger)def minValue:(NSInteger)min;
- (NSInteger)fc_integerValueWithDefault:(NSInteger)def minValue:(NSInteger)min maxValue:(NSInteger)max;
@end

NS_ASSUME_NONNULL_END
