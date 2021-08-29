//
//  NSString+FCArrayValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import <Foundation/Foundation.h>

@class UIColor;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCArrayValue)
- (NSArray<NSNumber *> *)floatArrayWithDefault:(NSArray *)def;
- (NSArray<UIColor *> *)colorArrayWithDefault:(NSArray *)def;
@end

NS_ASSUME_NONNULL_END
