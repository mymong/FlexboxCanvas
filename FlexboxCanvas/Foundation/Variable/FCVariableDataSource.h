//
//  FCVariableDataSource.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FCVariableDataSource <NSObject>
- (NSString *)variableValueForName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
