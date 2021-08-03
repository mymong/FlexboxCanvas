//
//  NSArray+FCValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (FCValue)

- (NSInteger)fc_enumValueForString:(NSString *)string defaultValue:(NSInteger)def;
- (NSString *)fc_stringForEnumValue:(NSInteger)enumValue defaultString:(NSString *)def;

@end

NS_ASSUME_NONNULL_END
