//
//  FCComponent.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import <Foundation/Foundation.h>
#import "FCComponentParent.h"
#import "FCComponentHierachy.h"

@class FCElement;
@class FCComponentParams;
@protocol FC_Node;

NS_ASSUME_NONNULL_BEGIN

@interface FCComponent : NSObject <FCComponentParent, FCComponentHierachy>

+ (instancetype)componentWithElement:(FCElement *)element;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *key;
- (instancetype)initWithElement:(FCElement *)element;
- (void)reloadElement:(FCElement *)element;

@property (nonatomic, readonly, nullable) id<FCComponentParent> parent;
- (void)moveToParent:(id<FCComponentParent>)parent;
- (void)removeFromParent;

@property (nonatomic, nullable, readonly) NSArray<FCComponent *> *children;
//- (void)buildChildren:(NSArray<FCElement *> *)elements;

@property (nonatomic, readonly) __kindof FCComponentParams *props;
- (Class)propsClass;

- (nullable id<FC_Node>)node;
- (void)startNode;
- (void)linkSubnodes;
- (void)finishNode;

@property (nonatomic) CGRect frame;
- (void)startManagedView;
- (void)moveManagedView;
- (void)finishManagedView;
- (BOOL)isTouchable;

- (void)sendEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender;

@end

NS_ASSUME_NONNULL_END
