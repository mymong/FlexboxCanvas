//
//  FCComponentAttributes.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import <Foundation/Foundation.h>

@protocol FCComponentParent;
@class FCVariableDictionary;

NS_ASSUME_NONNULL_BEGIN

@interface FCComponentAttributes : NSObject
//Init with its owner component.
- (instancetype)initWithComponent:(id<FCComponentParent>)component;
//Reload from element-attributes to restart variable listening.
- (void)reload:(nullable FCVariableDictionary *)variableDictionary;
//Convert to render-attributes by applying its variables.
- (NSDictionary<NSString *, NSString *> *)dictionary;
//Is any variable changed.
- (BOOL)isDirty;
@end

NS_ASSUME_NONNULL_END
