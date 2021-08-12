//
//  NSString+FCSizeValue.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCSizeValue)
- (CGSize)fc_sizeValueWithDefault:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
