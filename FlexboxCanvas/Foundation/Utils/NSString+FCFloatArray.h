//
//  NSString+FCFloatArray.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCFloatArray)
- (NSArray<NSNumber *> *)fc_floatArrayWithDefault:(float)def;
@end

NS_ASSUME_NONNULL_END
