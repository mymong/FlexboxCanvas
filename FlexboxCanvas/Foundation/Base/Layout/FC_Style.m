//
//  FC_Style.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import "FC_Style.h"

static BOOL g_fc_isRTL = NO;

BOOL FC_GetIsRTL(void) {
    return g_fc_isRTL;
}

void FC_SetIsRTL(BOOL isRTL) {
    g_fc_isRTL = isRTL;
}

void FC_Style_Init(FC_Style *style) {
    style->direction = FC_Direction_Inherit;
    style->flexDirection = FC_FlexDirection_Column;
    style->justifyContent = FC_Justify_FlexStart;
    style->alignContent = FC_Align_FlexStart;
    style->alignItems = FC_Align_Stretch;
    style->alignSelf = FC_Align_Auto;
    style->positionType = FC_PositionType_Relative;
    style->flexWrap = FC_Wrap_NoWrap;
    style->overflow = FC_Overflow_Visible;
    style->display = FC_Display_Flex;
    style->flex = NAN;
    style->flexGrow = NAN;
    style->flexShrink = NAN;
    style->flexBasis = NAN;
    for (FC_Edge edge = 0; edge < FC_Edge_Count; edge ++) {
        style->margin[edge] = NAN;
        style->position[edge] = NAN;
        style->padding[edge] = NAN;
        style->border[edge] = NAN;
    }
    for (FC_Dimension i = 0; i < FC_Dimension_Count; i ++) {
        style->dimension[i] = NAN;
        style->minDimension[i] = NAN;
        style->maxDimension[i] = NAN;
    }
    style->aspectRatio = NAN;
}

void FC_Style_GetInsets(float *edges, UIEdgeInsets *insets) {
    float v = edges[FC_Edge_Left];
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
