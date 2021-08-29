//
//  FCVariableDictionary.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/28.
//

#import "FCVariableString.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCVariableDictionary : NSObject
+ (instancetype)variableDictionaryWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, readonly, nullable) NSArray<NSString *> *names;
- (NSDictionary *)dictionaryWithDataSource:(id<FCVariableDataSource>)dataSource;
@end

NS_ASSUME_NONNULL_END
