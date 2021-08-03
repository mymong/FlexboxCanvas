//
//  FCCanvas.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import <Foundation/Foundation.h>

@protocol FCVariableListener;

NS_ASSUME_NONNULL_BEGIN

@protocol FCCanvas <NSObject>
// native
- (nullable UIView *)nativeViewForKey:(NSString *)key;
// event
- (void)onEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender;
// variable
- (nullable NSString *)variableValueForName:(NSString *)name;
- (void)addVariableListener:(id<FCVariableListener>)listener forNames:(NSArray<NSString *> *)names;
- (void)removeVariableListener:(id<FCVariableListener>)listener;
@end

NS_ASSUME_NONNULL_END
