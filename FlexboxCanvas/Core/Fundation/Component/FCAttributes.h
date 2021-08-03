//
//  FCAttributes.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import <Foundation/Foundation.h>

@protocol FCComponentParent;

NS_ASSUME_NONNULL_BEGIN

@interface FCAttributes : NSObject
//To create component attributes formatter.
- (instancetype)initWithComponent:(id<FCComponentParent>)component;
//Reload from element attributes and format variables.
- (void)reload:(nullable NSDictionary<NSString *, NSString *> *)dictionary;
//Convert to component attributes by applying variables.
- (NSMutableDictionary<NSString *, NSString *> *)dictionary;
//Is any variable changed.
- (BOOL)isDirty;
@end

NS_ASSUME_NONNULL_END
