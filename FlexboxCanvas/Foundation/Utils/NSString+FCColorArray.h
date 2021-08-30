//
//  NSString+FCColorArray.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCColorArray)
- (NSArray<UIColor *> *)fc_colorArrayWithDefault:(UIColor *)def;
@end

NS_ASSUME_NONNULL_END
