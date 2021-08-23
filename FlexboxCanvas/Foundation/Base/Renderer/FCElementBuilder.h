//
//  FCElementBuilder.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/23.
//

#import <Foundation/Foundation.h>

@class FCElement;

NS_ASSUME_NONNULL_BEGIN

@protocol FCElementBuilder <NSObject>
- (nullable FCElement *)elementWithXMLData:(NSData *)data;
- (nullable FCElement *)elementWithXMLString:(NSString *)string;
@end

@interface FCElementBuilder : NSObject
+ (id<FCElementBuilder>)builder;
+ (void)registerBuilder:(id<FCElementBuilder>)builder;
@end

NS_ASSUME_NONNULL_END
