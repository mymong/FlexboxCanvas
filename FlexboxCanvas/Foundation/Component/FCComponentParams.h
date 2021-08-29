//
//  FCComponentParams.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCComponentParams : NSObject
- (void)reset;
- (NSInteger)maxConnectorLevel;
- (NSDictionary *)setFromDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)setFromDictionary:(NSDictionary *)dictionary connector:(NSString *)connector;
@end

NS_ASSUME_NONNULL_END
