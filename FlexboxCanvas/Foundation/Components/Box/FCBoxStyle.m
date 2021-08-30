//
//  FCBoxStyle.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/11.
//

#import "FCBoxStyle.h"
#import "NSString+FCStyleString.h"
#import "NSString+FCFloatValue.h"
#import "NSArray+FCEnumValue.h"

static NSArray<NSString *> *FCEnumStrsDirection;
static NSArray<NSString *> *FCEnumStrsFlexDirection;
static NSArray<NSString *> *FCEnumStrsJustify;
static NSArray<NSString *> *FCEnumStrsAlign;
static NSArray<NSString *> *FCEnumStrsPositionType;
static NSArray<NSString *> *FCEnumStrsWrap;
static NSArray<NSString *> *FCEnumStrsOverflow;
static NSArray<NSString *> *FCEnumStrsDisplay;

void FCLayoutStyle_EnumStrs_Setup(void) {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        FCEnumStrsDirection = @[@"inherit", @"ltr", @"rtl"];
        FCEnumStrsFlexDirection = @[@"column", @"columnReverse", @"row", @"rowReverse"];
        FCEnumStrsJustify = @[@"flexStart", @"center", @"flexEnd", @"spaceBetween", @"spaceAround", @"spaceEvenly"];
        FCEnumStrsAlign = @[@"auto", @"flexStart", @"center", @"flexEnd", @"stretch", @"baseline", @"spaceBetween", @"spaceAround"];
        FCEnumStrsPositionType = @[@"relative", @"absolute"];
        FCEnumStrsWrap = @[@"noWrap", @"wrap", @"wrapReverse"];
        FCEnumStrsOverflow = @[@"visible", @"hidden"/*, @"scroll"*/];
        FCEnumStrsDisplay = @[@"flex", @"none"];
    });
}

@implementation FCBoxStyle {
   FCLayoutStyle _style;
}

- (FCLayoutStyle *)styleRef {
   return &_style;
}

- (instancetype)init {
   if (self = [super init]) {
       FCLayoutStyle_EnumStrs_Setup();
   }
   return self;
}

- (void)reset {
    [super reset];
    FCLayoutStyleInit(&_style);
}

- (NSInteger)maxConnectorLevel {
    return 4;
}

- (void)setFromString:(NSString *)string {
    NSParameterAssert(string && string.length);
    NSDictionary *dictionary = [string fc_styleDictionary];
    if (dictionary.count > 0) {
        [self setFromDictionary:dictionary];
    }
}

#pragma mark level 1

- (void)set_direction:(NSString *)str {
    _style.direction = (FC_Direction)[FCEnumStrsDirection fc_enumValueForStr:str defaultValue:FC_Direction_Inherit];
}

- (void)set_flexDirection:(NSString *)str {
    _style.flexDirection = (FC_FlexDirection)[FCEnumStrsFlexDirection fc_enumValueForStr:str defaultValue:FC_FlexDirection_Column];
}

- (void)set_justifyContent:(NSString *)str {
    _style.justifyContent = (FC_Justify)[FCEnumStrsJustify fc_enumValueForStr:str defaultValue:FC_Justify_FlexStart];
}

- (void)set_alignContent:(NSString *)str {
    _style.alignContent = (FC_Align)[FCEnumStrsAlign fc_enumValueForStr:str defaultValue:FC_Align_FlexStart];
}

- (void)set_alignItems:(NSString *)str {
    _style.alignItems = (FC_Align)[FCEnumStrsAlign fc_enumValueForStr:str defaultValue:FC_Align_Stretch];
}

- (void)set_alignSelf:(NSString *)str {
    _style.alignSelf = (FC_Align)[FCEnumStrsAlign fc_enumValueForStr:str defaultValue:FC_Align_Auto];
}

- (void)set_positionType:(NSString *)str {
    _style.positionType = (FC_PositionType)[FCEnumStrsPositionType fc_enumValueForStr:str defaultValue:FC_PositionType_Relative];
}

- (void)set_flexWrap:(NSString *)str {
    _style.flexWrap = (FC_Wrap)[FCEnumStrsWrap fc_enumValueForStr:str defaultValue:FC_Wrap_NoWrap];
}

- (void)set_overflow:(NSString *)str {
    _style.overflow = (FC_Overflow)[FCEnumStrsOverflow fc_enumValueForStr:str defaultValue:FC_Overflow_Visible];
}

- (void)set_display:(NSString *)str {
    _style.display = (FC_Display)[FCEnumStrsDisplay fc_enumValueForStr:str defaultValue:FC_Display_Flex];
}

- (void)set_flex:(NSString *)str {
    _style.flex = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set_flexGrow:(NSString *)str {
    _style.flexGrow = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set_flexShrink:(NSString *)str {
    _style.flexShrink = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set_flexBasis:(NSString *)str {
    _style.flexBasis = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set_margin:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    for (FC_Edge i = 0; i < FC_Edge_Count; i ++) {
        _style.margin[i] = val;
    }
}

- (void)set_position:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    for (FC_Edge i = 0; i < FC_Edge_Count; i ++) {
        _style.position[i] = val;
    }
}

- (void)set_padding:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    for (FC_Edge i = 0; i < FC_Edge_Count; i ++) {
        _style.padding[i] = val;
    }
}

- (void)set_border:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    for (FC_Edge i = 0; i < FC_Edge_Count; i ++) {
        _style.border[i] = val;
    }
}

- (void)set_dimension:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    for (FC_Dimension i = 0; i < FC_Dimension_Count; i ++) {
        _style.dimension[i] = val;
    }
}

- (void)set_minDimension:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    for (FC_Dimension i = 0; i < FC_Dimension_Count; i ++) {
        _style.minDimension[i] = val;
    }
}

- (void)set_maxDimension:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    for (FC_Dimension i = 0; i < FC_Dimension_Count; i ++) {
        _style.maxDimension[i] = val;
    }
}

#pragma mark level 2

- (void)set__marginHorizontal:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    _style.margin[FC_Edge_Left] = val;
    _style.margin[FC_Edge_Right] = val;
}

- (void)set__marginVertical:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    _style.margin[FC_Edge_Top] = val;
    _style.margin[FC_Edge_Bottom] = val;
}

- (void)set__positionHorizontal:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    _style.position[FC_Edge_Left] = val;
    _style.position[FC_Edge_Right] = val;
}

- (void)set__positionVertical:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    _style.position[FC_Edge_Top] = val;
    _style.position[FC_Edge_Bottom] = val;
}

- (void)set__paddingHorizontal:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    _style.padding[FC_Edge_Left] = val;
    _style.padding[FC_Edge_Right] = val;
}

- (void)set__paddingVertical:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    _style.padding[FC_Edge_Top] = val;
    _style.padding[FC_Edge_Bottom] = val;
}

- (void)set__borderHorizontal:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    _style.border[FC_Edge_Left] = val;
    _style.border[FC_Edge_Right] = val;
}

- (void)set__borderVertical:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    _style.border[FC_Edge_Top] = val;
    _style.border[FC_Edge_Bottom] = val;
}

- (void)set__width:(NSString *)str {
    _style.dimension[FC_Dimension_Width] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set__height:(NSString *)str {
    _style.dimension[FC_Dimension_Height] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set__minWidth:(NSString *)str {
    _style.minDimension[FC_Dimension_Width] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set__minHeight:(NSString *)str {
    _style.minDimension[FC_Dimension_Height] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set__maxWidth:(NSString *)str {
    _style.maxDimension[FC_Dimension_Width] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set__maxHeight:(NSString *)str {
    _style.maxDimension[FC_Dimension_Height] = [str fc_abs_floatValueWithDefault:NAN];
}

#pragma mark level 3

- (void)set___marginStart:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    if (FCLayoutGetIsRTL()) {
        _style.margin[FC_Edge_Right] = val;
    } else {
        _style.margin[FC_Edge_Left] = val;
    }
}

- (void)set___marginEnd:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    if (FCLayoutGetIsRTL()) {
        _style.margin[FC_Edge_Left] = val;
    } else {
        _style.margin[FC_Edge_Right] = val;
    }
}

- (void)set___positionStart:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    if (FCLayoutGetIsRTL()) {
        _style.position[FC_Edge_Right] = val;
    } else {
        _style.position[FC_Edge_Left] = val;
    }
}

- (void)set___positionEnd:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    if (FCLayoutGetIsRTL()) {
        _style.position[FC_Edge_Left] = val;
    } else {
        _style.position[FC_Edge_Right] = val;
    }
}

- (void)set___paddingStart:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    if (FCLayoutGetIsRTL()) {
        _style.padding[FC_Edge_Right] = val;
    } else {
        _style.padding[FC_Edge_Left] = val;
    }
}

- (void)set___paddingEnd:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    if (FCLayoutGetIsRTL()) {
        _style.padding[FC_Edge_Left] = val;
    } else {
        _style.padding[FC_Edge_Right] = val;
    }
}

- (void)set___borderStart:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    if (FCLayoutGetIsRTL()) {
        _style.border[FC_Edge_Right] = val;
    } else {
        _style.border[FC_Edge_Left] = val;
    }
}

- (void)set___borderEnd:(NSString *)str {
    float val = [str fc_abs_floatValueWithDefault:NAN];
    if (FCLayoutGetIsRTL()) {
        _style.border[FC_Edge_Left] = val;
    } else {
        _style.border[FC_Edge_Right] = val;
    }
}

#pragma mark level 4

- (void)set____marginLeft:(NSString *)str {
    _style.margin[FC_Edge_Left] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____marginTop:(NSString *)str {
    _style.margin[FC_Edge_Top] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____marginRight:(NSString *)str {
    _style.margin[FC_Edge_Right] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____marginBottom:(NSString *)str {
    _style.margin[FC_Edge_Bottom] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____positionLeft:(NSString *)str {
    _style.position[FC_Edge_Left] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____positionTop:(NSString *)str {
    _style.position[FC_Edge_Top] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____positionRight:(NSString *)str {
    _style.position[FC_Edge_Right] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____positionBottom:(NSString *)str {
    _style.position[FC_Edge_Bottom] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____paddingLeft:(NSString *)str {
    _style.padding[FC_Edge_Left] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____paddingTop:(NSString *)str {
    _style.padding[FC_Edge_Top] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____paddingRight:(NSString *)str {
    _style.padding[FC_Edge_Right] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____paddingBottom:(NSString *)str {
    _style.padding[FC_Edge_Bottom] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____borderLeft:(NSString *)str {
    _style.border[FC_Edge_Left] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____borderTop:(NSString *)str {
    _style.border[FC_Edge_Top] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____borderRight:(NSString *)str {
    _style.border[FC_Edge_Right] = [str fc_abs_floatValueWithDefault:NAN];
}

- (void)set____borderBottom:(NSString *)str {
    _style.border[FC_Edge_Bottom] = [str fc_abs_floatValueWithDefault:NAN];
}

@end

@implementation FCBoxStyle (Helper)

- (void)getDimensions:(CGSize *)dimensions {
    NSParameterAssert(dimensions);
    float v;
    v = _style.dimension[FC_Dimension_Width];
    if (!isnan(v)) {
        dimensions->width = v;
    }
    v = _style.dimension[FC_Dimension_Height];
    if (!isnan(v)) {
        dimensions->height = v;
    }
}

- (UIEdgeInsets)border {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    [self _getInsets:&insets fromEdges:_style.border];
    return insets;
}

- (UIEdgeInsets)contentInsets {
    UIEdgeInsets insets = UIEdgeInsetsZero;
    [self _addInsets:&insets fromEdges:_style.border];
    [self _addInsets:&insets fromEdges:_style.padding];
    return insets;
}

- (void)_getInsets:(UIEdgeInsets *)insets fromEdges:(float *)edges {
    float v;
    v = edges[FC_Edge_Left];
    if (!isnan(v)) {
        insets->left = v;
    }
    v = edges[FC_Edge_Top];
    if (!isnan(v)) {
        insets->top = v;
    }
    v = edges[FC_Edge_Right];
    if (!isnan(v)) {
        insets->right = v;
    }
    v = edges[FC_Edge_Bottom];
    if (!isnan(v)) {
        insets->bottom = v;
    }
}

- (void)_addInsets:(UIEdgeInsets *)insets fromEdges:(float *)edges {
    float v;
    v = edges[FC_Edge_Left];
    if (!isnan(v)) {
        insets->left += v;
    }
    v = edges[FC_Edge_Top];
    if (!isnan(v)) {
        insets->top += v;
    }
    v = edges[FC_Edge_Right];
    if (!isnan(v)) {
        insets->right += v;
    }
    v = edges[FC_Edge_Bottom];
    if (!isnan(v)) {
        insets->bottom += v;
    }
}

@end

@implementation FCBoxStyle (EnumStrs)

- (NSArray<NSString *> *)enumStrsOverflow {
    return FCEnumStrsOverflow;
}

@end
