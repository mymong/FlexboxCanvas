//
//  NSString+FCStyleString.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/31.
//

#import <Foundation/Foundation.h>

@class FCKeyValuePair;

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCStyleString)
- (NSDictionary<NSString *, NSString *> *)fc_styleDictionary;
@end

NS_ASSUME_NONNULL_END
