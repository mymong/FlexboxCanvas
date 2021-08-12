//
//  FCVariableString.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/25.
//

#import "FCVariableString.h"
#import "FCVariableDataSource.h"

@interface FCVariableString ()
@property (nonatomic, readonly) NSString *format;
@end

@implementation FCVariableString

- (instancetype)initWithFormat:(NSString *)format names:(NSArray<NSString *> *)names {
    if (self = [super init]) {
        _format = format ?: @"";
        _names = names;
    }
    return self;
}

+ (instancetype)variableStringWithString:(NSString *)string {
    NSParameterAssert(string);
    if (!string) {
        return nil;
    }
    
    NSInteger len = string.length;
    if (len < 3) {
        return [[FCVariableString alloc] initWithFormat:string names:nil];
    }
    
    static NSRegularExpression *regex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        regex = [NSRegularExpression regularExpressionWithPattern:@"\\{[\\w/#&=,\\;\\:\\.\\|\\?\\-]*\\}" options:0 error:NULL];
    });
    
    NSTextCheckingResult *result = [regex firstMatchInString:string options:0 range:NSMakeRange(0, len)];
    if (!result) {
        return [[FCVariableString alloc] initWithFormat:string names:nil];
    }
    
    NSMutableString *format = string.mutableCopy;
    NSMutableArray<NSString *> *names = [NSMutableArray new];
    NSString *name;
    NSInteger loc = 0;
    
    do {
        name = [format substringWithRange:result.range];
        name = [name substringWithRange:NSMakeRange(1, name.length - 2)];
        [names addObject:name];
        
        [format replaceCharactersInRange:result.range withString:@"%@"];
        len = format.length;
        loc = result.range.location + 2;
        
        result = [regex firstMatchInString:format options:0 range:NSMakeRange(loc, len - loc)];
    } while(result);
    
    return [[FCVariableString alloc] initWithFormat:format names:names];
}

- (NSString *)stringWithDataSource:(id<FCVariableDataSource>)dataSource {
    NSArray *names = self.names;
    if (!names) {
        return self.format;
    }
    
    NSUInteger count = names.count;
    if (!count) {
        return self.format;
    }
    
    NSArray *comps = [self.format componentsSeparatedByString:@"%@"];
    if (comps.count < count) {
        return self.format;
    }
    
    NSMutableArray *strs = [NSMutableArray new];
    NSString *str;
    NSInteger i = 0;
    for (; i < count; i ++) {
        str = comps[i];
        [strs addObject:str];
        str = names[i];
        str = [dataSource variableValueForName:str] ?: @"";
        [strs addObject:str];
    }
    for (; i < comps.count; i ++) {
        str = comps[i];
        [strs addObject:str];
    }
    return [strs componentsJoinedByString:@""];
}

@end
