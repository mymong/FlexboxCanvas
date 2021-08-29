//
//  FCVariableString.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/25.
//

#import "FCVariableDataSource.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCVariableString : NSObject
+ (instancetype)variableStringWithString:(NSString *)string;
@property (nonatomic, readonly, nullable) NSArray<NSString *> *names;
- (NSString *)stringWithDataSource:(id<FCVariableDataSource>)dataSource;
@end

NS_ASSUME_NONNULL_END
