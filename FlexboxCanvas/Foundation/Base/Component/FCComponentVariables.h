//
//  FCComponentVariables.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import <Foundation/Foundation.h>

@protocol FCComponentParent;
@class FCComponentProps;

NS_ASSUME_NONNULL_BEGIN

@interface FCComponentVariables : NSObject
- (instancetype)initWithComponent:(id<FCComponentParent>)component;
//Reload from element attributes to parse variables formatter.
- (void)reload:(nullable NSDictionary<NSString *, NSString *> *)dictionary;
//Convert to component attributes by applying variables.
- (NSDictionary<NSString *, NSString *> *)dictionary;
//Return dirty attributes.
- (NSDictionary<NSString *, NSString *> *)changes;
//Is any variable changed.
- (BOOL)isDirty;
@end

NS_ASSUME_NONNULL_END
