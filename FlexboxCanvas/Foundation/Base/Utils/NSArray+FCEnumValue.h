//
//  NSArray+FCEnumValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (FCEnumValue)
- (NSInteger)fc_enumValueForStr:(NSString *)str defaultValue:(NSInteger)def;
@end

NS_ASSUME_NONNULL_END
