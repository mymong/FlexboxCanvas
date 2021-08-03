//
//  FCVariableListener.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FCVariableListener <NSObject>
- (void)onChangeVariableForName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
