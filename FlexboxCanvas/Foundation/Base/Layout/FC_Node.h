//
//  FC_Node.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import "FC_Style.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FC_Node <NSObject>
- (void)setStyle:(FC_Style *)styleRef;
- (void)setStyleSize:(CGSize)size;
- (void)setSubnodes:(nullable NSArray<id<FC_Node>> *)subnodes;
- (void)calculateInSize:(CGSize)size;
- (CGRect)frame;
@end

@interface FC_Node : NSObject
+ (id<FC_Node>)node;
+ (void)registerClass:(Class)clazz;
@property (class) BOOL isRTL;
@end

NS_ASSUME_NONNULL_END
