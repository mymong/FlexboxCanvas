//
//  FCComponent.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import <Foundation/Foundation.h>
#import "FCComponentParent.h"
#import "FCComponentRendering.h"

@class FCElement;
@class FCComponentParams;
@protocol FCLayoutNode;

NS_ASSUME_NONNULL_BEGIN

@interface FCComponent : NSObject <FCComponentParent, FCComponentRendering>

+ (instancetype)componentWithElement:(FCElement *)element;

@property (nonatomic, readonly) __kindof FCComponentParams *props;
- (Class)propsClass;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *key;
- (instancetype)initWithElement:(FCElement *)element;
- (void)reload:(FCElement *)element;

@property (nonatomic, readonly, nullable) id<FCComponentParent> parent;
- (void)moveToParent:(id<FCComponentParent>)parent;
- (void)removeFromParent;

@property (nonatomic, readonly, nullable) NSArray<FCComponent *> *children;

- (nullable id<FCLayoutNode>)node;
- (void)configNodeTree;

@property (nonatomic) CGRect frame;
- (void)decideChildFrames;

- (void)buildManagedView;
- (void)moveManagedView;
- (void)finishManagedView;
- (BOOL)isTouchable;

- (void)sendEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender;

@end

NS_ASSUME_NONNULL_END
