//
//  FC_Node_Yoga_1_14.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FC_Node_Yoga_1_14.h"
#import <yoga/Yoga.h>

@interface FC_Node_Yoga_1_14 ()
@property (nonatomic, readonly) YGNodeRef nodeRef;
@end

@implementation FC_Node_Yoga_1_14

+ (void)load {
    [FC_Node registerClass:self];
}

- (void)dealloc {
    YGNodeFree(_nodeRef);
}

- (instancetype)init {
    if (self = [super init]) {
        _nodeRef = YGNodeNew();
    }
    return self;
}

- (void)setStyle:(FC_Style *)styleRef {
    YGNodeStyleSetDirection(_nodeRef, (YGDirection)(styleRef->direction));
    YGNodeStyleSetFlexDirection(_nodeRef, (YGFlexDirection)(styleRef->flexDirection));
    YGNodeStyleSetJustifyContent(_nodeRef, (YGJustify)(styleRef->justifyContent));
    YGNodeStyleSetAlignContent(_nodeRef, (YGAlign)(styleRef->alignContent));
    YGNodeStyleSetAlignItems(_nodeRef, (YGAlign)(styleRef->alignItems));
    YGNodeStyleSetAlignSelf(_nodeRef, (YGAlign)(styleRef->alignSelf));
    YGNodeStyleSetPositionType(_nodeRef, (YGPositionType)(styleRef->positionType));
    YGNodeStyleSetFlexWrap(_nodeRef, (YGWrap)(styleRef->flexWrap));
    YGNodeStyleSetOverflow(_nodeRef, (YGOverflow)(styleRef->overflow));
    YGNodeStyleSetDisplay(_nodeRef, (YGDisplay)(styleRef->display));
    YGNodeStyleSetFlex(_nodeRef, styleRef->flex);
    YGNodeStyleSetFlexGrow(_nodeRef, styleRef->flexGrow);
    YGNodeStyleSetFlexShrink(_nodeRef, styleRef->flexShrink);
    YGNodeStyleSetFlexBasis(_nodeRef, styleRef->flexBasis);
    for (NSInteger i = 0; i < FC_Edge_Count; i ++) {
        YGNodeStyleSetMargin(_nodeRef, (YGEdge)i, styleRef->margin[i]);
        YGNodeStyleSetPosition(_nodeRef, (YGEdge)i, styleRef->position[i]);
        YGNodeStyleSetPadding(_nodeRef, (YGEdge)i, styleRef->padding[i]);
        YGNodeStyleSetBorder(_nodeRef, (YGEdge)i, styleRef->border[i]);
    }
    YGNodeStyleSetWidth(_nodeRef, styleRef->dimension[FC_Dimension_Width]);
    YGNodeStyleSetHeight(_nodeRef, styleRef->dimension[FC_Dimension_Height]);
    YGNodeStyleSetMinWidth(_nodeRef, styleRef->minDimension[FC_Dimension_Width]);
    YGNodeStyleSetMinHeight(_nodeRef, styleRef->minDimension[FC_Dimension_Height]);
    YGNodeStyleSetMaxWidth(_nodeRef, styleRef->maxDimension[FC_Dimension_Width]);
    YGNodeStyleSetMaxHeight(_nodeRef, styleRef->maxDimension[FC_Dimension_Height]);
    YGNodeStyleSetAspectRatio(_nodeRef, styleRef->aspectRatio);
}

- (void)setSubnodes:(NSArray<id<FC_Node>> *)subnodes {
    YGNodeRemoveAllChildren(_nodeRef);
    if (subnodes) {
        for (FC_Node_Yoga_1_14 *node in subnodes) {
            YGNodeInsertChild(_nodeRef, node.nodeRef, YGNodeGetChildCount(_nodeRef));
        }
    }
}

- (void)setStyleSize:(CGSize)size {
    YGNodeStyleSetWidth(_nodeRef, size.width);
    YGNodeStyleSetHeight(_nodeRef, size.height);
}

- (float)aspectRatio {
    return YGNodeStyleGetAspectRatio(_nodeRef);
}

- (void)setAspectRatio:(float)aspectRatio {
    YGNodeStyleSetAspectRatio(_nodeRef, aspectRatio);
}

- (void)calculateInSize:(CGSize)size {
    YGDirection direction = YGDirectionLTR;
    if (FC_GetIsRTL()) {
        direction = YGDirectionRTL;
    }
    YGNodeCalculateLayout(_nodeRef, size.width, size.height, direction);
}

- (CGRect)frame {
    CGRect frame = CGRectZero;
    frame.origin.x = YGNodeLayoutGetLeft(_nodeRef);
    frame.origin.y = YGNodeLayoutGetTop(_nodeRef);
    frame.size.width = YGNodeLayoutGetWidth(_nodeRef);
    frame.size.height = YGNodeLayoutGetHeight(_nodeRef);
    return frame;
}

@end
