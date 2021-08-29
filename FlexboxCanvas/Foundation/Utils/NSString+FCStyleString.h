//
//  NSString+FCComponentStyleString.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/31.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (FCComponentStyleString)
- (NSDictionary<NSString *, NSString *> *)FCLayoutStyleDictionary;
@end

NS_ASSUME_NONNULL_END
