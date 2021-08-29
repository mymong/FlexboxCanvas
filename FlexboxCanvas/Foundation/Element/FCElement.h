//
//  FCElement.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import <Foundation/Foundation.h>

@class FCVariableDictionary;

NS_ASSUME_NONNULL_BEGIN

@interface FCElement : NSObject
@property (nonatomic, readonly) NSString *name; //元素名称
@property (nonatomic, readonly, nullable) FCVariableDictionary *attributes; //元素属性
@property (nonatomic, readonly, nullable) NSArray<FCElement *> *children; //子元素表
@property (nonatomic, readonly) NSString *key;
- (instancetype)initWithName:(NSString *)name attributes:(NSDictionary *)attributes children:(NSArray *)children defaultKey:(NSString *)defaultKey;
+ (nullable FCElement *)elementWithXMLString:(NSString *)string;
+ (nullable FCElement *)elementWithXMLResource:(NSString *)name inBundle:(nullable NSBundle *)bundle;
@end

NS_ASSUME_NONNULL_END
