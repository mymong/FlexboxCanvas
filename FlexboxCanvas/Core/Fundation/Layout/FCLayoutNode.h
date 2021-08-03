//
//  FCLayoutNode.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FCLayoutNode <NSObject>
- (void)applyStyle:(nullable NSDictionary *)style;
- (void)setSubnodes:(nullable NSArray<id<FCLayoutNode>> *)subnodes;
- (void)calculateInSize:(CGSize)size;
- (CGRect)frame;
- (void)setSize:(CGSize)size;
@end

@interface FCLayoutNodeFactory : NSObject
+ (id<FCLayoutNode>)node;
+ (void)registerLayoutNodeClass:(Class)clazz;
@end

NS_ASSUME_NONNULL_END
