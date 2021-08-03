//
//  FCComponent.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import <Foundation/Foundation.h>
#import "FCComponentLayout.h"
#import "FCComponentParent.h"
#import "FCComponentChild.h"
#import "FCComponentHierachy.h"

@class FCAttributes;
@class FCElement;

NS_ASSUME_NONNULL_BEGIN

@interface FCComponent : NSObject <FCComponentLayout, FCComponentParent, FCComponentChild, FCComponentHierachy>

+ (instancetype)componentWithElement:(FCElement *)element;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *key;
- (instancetype)initWithElement:(FCElement *)element;
- (void)reloadElement:(FCElement *)element;

@property (nonatomic, readonly, nullable) id<FCComponentParent> parent;
- (void)moveToParent:(id<FCComponentParent>)parent;
- (void)removeFromParent;

@property (nonatomic, nullable, readonly) NSArray<FCComponent *> *children;
- (void)buildChildren:(NSArray<FCElement *> *)elements props:(nullable NSDictionary *)props;
- (void)applyLayoutStyle:(nullable NSDictionary *)style;
- (void)linkLayoutTree;
- (void)frameChildren;
- (void)startManagedView:(nullable NSDictionary *)props;
- (void)finishManagedView;
- (void)sendEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender;
@end

NS_ASSUME_NONNULL_END
