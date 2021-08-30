//
//  NSString+FCPointValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCPointValue)
- (CGPoint)fc_pointValueWithDefault:(CGPoint)size;
@end

NS_ASSUME_NONNULL_END
