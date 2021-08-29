//
//  FCLayoutNode.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import "FCLayoutStyle.h"
#import "FCLayoutMeasure.h"

NS_ASSUME_NONNULL_BEGIN

@protocol FCLayoutNode <NSObject>
- (void)setStyle:(FCLayoutStyle *)styleRef;
- (void)setSubnodes:(nullable NSArray<id<FCLayoutNode>> *)subnodes;
- (void)setMeasurer:(nullable id<FCLayoutMeasure>)measurer;
- (void)setStyleSize:(CGSize)size;
- (void)markDirty;
- (float)aspectRatio;
- (void)setAspectRatio:(float)aspectRatio;
- (void)calculateInSize:(CGSize)size;
- (CGRect)frame;
@end

@interface FCLayoutNode : NSObject
+ (id<FCLayoutNode>)node;
+ (void)registerClass:(Class)clazz;
@property (class) BOOL isRTL;
@end

NS_ASSUME_NONNULL_END
