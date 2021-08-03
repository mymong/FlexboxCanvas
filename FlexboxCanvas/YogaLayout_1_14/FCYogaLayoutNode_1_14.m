//
//  FCYogaLayoutNode_1_14.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/23.
//

#import "FCYogaLayoutNode_1_14.h"
#import <yoga/Yoga.h>
#import "NSArray+FCValue.h"

static YGNodeRef YGNodeZeroRef;
static NSArray<NSString *> *FCEnumStrsDirection;
static NSArray<NSString *> *FCEnumStrsFlexDirection;
static NSArray<NSString *> *FCEnumStrsJustify;
static NSArray<NSString *> *FCEnumStrsAlign;
static NSArray<NSString *> *FCEnumStrsPositionType;
static NSArray<NSString *> *FCEnumStrsWrap;
static NSArray<NSString *> *FCEnumStrsOverflow;
static NSArray<NSString *> *FCEnumStrsDisplay;

@interface FCYogaLayoutNode_1_14 ()
@property (nonatomic, readonly) YGNodeRef nodeRef;
@end

@implementation FCYogaLayoutNode_1_14

+ (void)load {
    [FCLayoutNodeFactory registerLayoutNodeClass:self];
    YGNodeZeroRef = YGNodeNew();
    
    FCEnumStrsDirection = @[@"inherit", @"ltr", @"rtl"];
    FCEnumStrsFlexDirection = @[@"column", @"columnReverse", @"row", @"rowReverse"];
    FCEnumStrsJustify = @[@"flexStart", @"center", @"flexEnd", @"spaceBetween", @"spaceAround", @"spaceEvenly"];
    FCEnumStrsAlign = @[@"auto", @"flexStart", @"center", @"flexEnd", @"stretch", @"baseline", @"spaceBetween", @"spaceAround"];
    FCEnumStrsPositionType = @[@"relative", @"absolute"];
    FCEnumStrsWrap = @[@"noWrap", @"wrap", @"wrapReverse"];
    FCEnumStrsOverflow = @[@"visible", @"hidden", @"scroll"];
    FCEnumStrsDisplay = @[@"flex", @"none"];
}

- (instancetype)init {
    if (self = [super init]) {
        _nodeRef = YGNodeNew();
    }
    return self;
}

- (void)applyStyle:(nullable NSDictionary *)style {
    YGNodeCopyStyle(_nodeRef, YGNodeZeroRef);
    
    if (!style || 0 == style.count) {
        return;
    }
    
    NSString *str;
    
    if ((str = style[@"direction"])) {
        YGNodeStyleSetDirection(_nodeRef, (YGDirection)[FCEnumStrsDirection fc_enumValueForString:str defaultValue:YGDirectionInherit]);
    }
    if ((str = style[@"flexDirection"])) {
        YGNodeStyleSetFlexDirection(_nodeRef, (YGFlexDirection)[FCEnumStrsFlexDirection fc_enumValueForString:str defaultValue:YGFlexDirectionColumn]);
    }
    if ((str = style[@"justifyContent"])) {
        YGNodeStyleSetJustifyContent(_nodeRef, (YGJustify)[FCEnumStrsJustify fc_enumValueForString:str defaultValue:YGJustifyFlexStart]);
    }
    if ((str = style[@"alignContent"])) {
        YGNodeStyleSetAlignContent(_nodeRef, (YGAlign)[FCEnumStrsAlign fc_enumValueForString:str defaultValue:YGAlignFlexStart]);
    }
    if ((str = style[@"alignItems"])) {
        YGNodeStyleSetAlignItems(_nodeRef, (YGAlign)[FCEnumStrsAlign fc_enumValueForString:str defaultValue:YGAlignStretch]);
    }
    if ((str = style[@"alignSelf"])) {
        YGNodeStyleSetAlignSelf(_nodeRef, (YGAlign)[FCEnumStrsAlign fc_enumValueForString:str defaultValue:YGAlignAuto]);
    }
    if ((str = style[@"positionType"])) {
        YGNodeStyleSetPositionType(_nodeRef, (YGPositionType)[FCEnumStrsPositionType fc_enumValueForString:str defaultValue:YGPositionTypeRelative]);
    }
    if ((str = style[@"flexWrap"])) {
        YGNodeStyleSetFlexWrap(_nodeRef, (YGWrap)[FCEnumStrsWrap fc_enumValueForString:str defaultValue:YGWrapNoWrap]);
    }
    if ((str = style[@"overflow"])) {
        YGNodeStyleSetOverflow(_nodeRef, (YGOverflow)[FCEnumStrsOverflow fc_enumValueForString:str defaultValue:YGOverflowVisible]);
    }
    if ((str = style[@"display"])) {
        YGNodeStyleSetDisplay(_nodeRef, (YGDisplay)[FCEnumStrsDisplay fc_enumValueForString:str defaultValue:YGDisplayFlex]);
    }
    
    if ((str = style[@"flex"])) {
        YGNodeStyleSetFlex(_nodeRef, [str floatValue]);
    }
    if ((str = style[@"flexGrow"])) {
        YGNodeStyleSetFlexGrow(_nodeRef, [str floatValue]);
    }
    if ((str = style[@"flexShrink"])) {
        YGNodeStyleSetFlexShrink(_nodeRef, [str floatValue]);
    }
    if ((str = style[@"flexBasis"])) {
        YGNodeStyleSetFlexBasis(_nodeRef, [str floatValue]);
    }
    
    if ((str = style[@"marginLeft"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeLeft, [str floatValue]);
    }
    if ((str = style[@"marginTop"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeTop, [str floatValue]);
    }
    if ((str = style[@"marginRight"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeRight, [str floatValue]);
    }
    if ((str = style[@"marginBottom"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeBottom, [str floatValue]);
    }
    if ((str = style[@"marginStart"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeStart, [str floatValue]);
    }
    if ((str = style[@"marginEnd"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeEnd, [str floatValue]);
    }
    if ((str = style[@"marginHorizontal"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeHorizontal, [str floatValue]);
    }
    if ((str = style[@"marginVertical"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeVertical, [str floatValue]);
    }
    if ((str = style[@"margin"])) {
        YGNodeStyleSetMargin(_nodeRef, YGEdgeAll, [str floatValue]);
    }
    
    if ((str = style[@"positionLeft"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeLeft, [str floatValue]);
    }
    if ((str = style[@"positionTop"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeTop, [str floatValue]);
    }
    if ((str = style[@"positionRight"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeRight, [str floatValue]);
    }
    if ((str = style[@"positionBottom"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeBottom, [str floatValue]);
    }
    if ((str = style[@"positionStart"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeStart, [str floatValue]);
    }
    if ((str = style[@"positionEnd"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeEnd, [str floatValue]);
    }
    if ((str = style[@"positionHorizontal"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeHorizontal, [str floatValue]);
    }
    if ((str = style[@"positionVertical"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeVertical, [str floatValue]);
    }
    if ((str = style[@"position"])) {
        YGNodeStyleSetPosition(_nodeRef, YGEdgeAll, [str floatValue]);
    }
    
    if ((str = style[@"paddingLeft"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeLeft, [str floatValue]);
    }
    if ((str = style[@"paddingTop"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeTop, [str floatValue]);
    }
    if ((str = style[@"paddingRight"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeRight, [str floatValue]);
    }
    if ((str = style[@"paddingBottom"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeBottom, [str floatValue]);
    }
    if ((str = style[@"paddingStart"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeStart, [str floatValue]);
    }
    if ((str = style[@"paddingEnd"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeEnd, [str floatValue]);
    }
    if ((str = style[@"paddingHorizontal"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeHorizontal, [str floatValue]);
    }
    if ((str = style[@"paddingVertical"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeVertical, [str floatValue]);
    }
    if ((str = style[@"padding"])) {
        YGNodeStyleSetPadding(_nodeRef, YGEdgeAll, [str floatValue]);
    }
    
    if ((str = style[@"borderLeft"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeLeft, [str floatValue]);
    }
    if ((str = style[@"borderTop"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeTop, [str floatValue]);
    }
    if ((str = style[@"borderRight"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeRight, [str floatValue]);
    }
    if ((str = style[@"borderBottom"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeBottom, [str floatValue]);
    }
    if ((str = style[@"borderStart"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeStart, [str floatValue]);
    }
    if ((str = style[@"borderEnd"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeEnd, [str floatValue]);
    }
    if ((str = style[@"borderHorizontal"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeHorizontal, [str floatValue]);
    }
    if ((str = style[@"borderVertical"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeVertical, [str floatValue]);
    }
    if ((str = style[@"border"])) {
        YGNodeStyleSetBorder(_nodeRef, YGEdgeAll, [str floatValue]);
    }
    
    if ((str = style[@"size"])) {
        float size = [str floatValue];
        YGNodeStyleSetWidth(_nodeRef, size);
        YGNodeStyleSetHeight(_nodeRef, size);
    }
    if ((str = style[@"width"])) {
        YGNodeStyleSetWidth(_nodeRef, [str floatValue]);
    }
    if ((str = style[@"height"])) {
        YGNodeStyleSetHeight(_nodeRef, [str floatValue]);
    }
    if ((str = style[@"minSize"])) {
        float size = [str floatValue];
        YGNodeStyleSetMinWidth(_nodeRef, size);
        YGNodeStyleSetMinHeight(_nodeRef, size);
    }
    if ((str = style[@"minWidth"])) {
        YGNodeStyleSetMinWidth(_nodeRef, [str floatValue]);
    }
    if ((str = style[@"minHeight"])) {
        YGNodeStyleSetMinHeight(_nodeRef, [str floatValue]);
    }
    if ((str = style[@"maxSize"])) {
        float size = [str floatValue];
        YGNodeStyleSetMaxWidth(_nodeRef, size);
        YGNodeStyleSetMaxHeight(_nodeRef, size);
    }
    if ((str = style[@"maxWidth"])) {
        YGNodeStyleSetMaxWidth(_nodeRef, [str floatValue]);
    }
    if ((str = style[@"maxHeight"])) {
        YGNodeStyleSetMaxHeight(_nodeRef, [str floatValue]);
    }
    
    if ((str = style[@"aspectRatio"])) {
        YGNodeStyleSetAspectRatio(_nodeRef, [str floatValue]);
    }
}

- (void)setSubnodes:(NSArray<id<FCLayoutNode>> *)subnodes {
    YGNodeRemoveAllChildren(_nodeRef);
    for (FCYogaLayoutNode_1_14 *node in subnodes) {
        YGNodeInsertChild(_nodeRef, node.nodeRef, YGNodeGetChildCount(_nodeRef));
    }
}

- (void)calculateInSize:(CGSize)size {
    YGNodeCalculateLayout(_nodeRef, size.width, size.height, YGDirectionLTR);
}

- (CGRect)frame {
    CGRect frame = CGRectZero;
    frame.origin.x = YGNodeLayoutGetLeft(_nodeRef);
    frame.origin.y = YGNodeLayoutGetTop(_nodeRef);
    frame.size.width = YGNodeLayoutGetWidth(_nodeRef);
    frame.size.height = YGNodeLayoutGetHeight(_nodeRef);
    return frame;
}

- (void)setSize:(CGSize)size {
    YGNodeStyleSetWidth(_nodeRef, size.width);
    YGNodeStyleSetHeight(_nodeRef, size.height);
    YGNodeStyleSetMinWidth(_nodeRef, YGUndefined);
    YGNodeStyleSetMinHeight(_nodeRef, YGUndefined);
    YGNodeStyleSetMaxWidth(_nodeRef, YGUndefined);
    YGNodeStyleSetMaxHeight(_nodeRef, YGUndefined);
}

@end
