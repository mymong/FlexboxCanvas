//
//  FCLayoutStyle.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import <Foundation/Foundation.h>

typedef enum FC_Align {
    FC_Align_Auto,
    FC_Align_FlexStart,
    FC_Align_Center,
    FC_Align_FlexEnd,
    FC_Align_Stretch,
    FC_Align_Baseline,
    FC_Align_SpaceBetween,
    FC_Align_SpaceAround,
} FC_Align;

typedef enum FC_Dimension {
    FC_Dimension_Width,
    FC_Dimension_Height,
    FC_Dimension_Count,
} FC_Dimension;

typedef enum FC_Direction {
    FC_Direction_Inherit,
    FC_Direction_LTR,
    FC_Direction_RTL,
} FC_Direction;

typedef enum FC_Display {
    FC_Display_Flex,
    FC_Display_None,
} FC_Display;

typedef enum FC_Edge {
    FC_Edge_Left,
    FC_Edge_Top,
    FC_Edge_Right,
    FC_Edge_Bottom,
    FC_Edge_Count,
} FC_Edge;

typedef enum FC_FlexDirection {
    FC_FlexDirection_Column,
    FC_FlexDirection_ColumnReverse,
    FC_FlexDirection_Row,
    FC_FlexDirection_RowReverse,
} FC_FlexDirection;

typedef enum FC_Justify {
    FC_Justify_FlexStart,
    FC_Justify_Center,
    FC_Justify_FlexEnd,
    FC_Justify_SpaceBetween,
    FC_Justify_SpaceAround,
    FC_Justify_SpaceEvenly,
} FC_Justify;

typedef enum FC_Overflow {
    FC_Overflow_Visible,
    FC_Overflow_Hidden,
    FC_Overflow_Scroll,
} FC_Overflow;

typedef enum FC_PositionType {
    FC_PositionType_Relative,
    FC_PositionType_Absolute,
} FC_PositionType;

typedef enum FC_Wrap {
    FC_Wrap_NoWrap,
    FC_Wrap_Wrap,
    FC_Wrap_WrapReverse,
} FC_Wrap;

typedef struct FCLayoutStyle {
    FC_Direction direction;
    FC_FlexDirection flexDirection;
    FC_Justify justifyContent;
    FC_Align alignContent;
    FC_Align alignItems;
    FC_Align alignSelf;
    FC_PositionType positionType;
    FC_Wrap flexWrap;
    FC_Overflow overflow;
    FC_Display display;
    float flex;
    float flexGrow;
    float flexShrink;
    float flexBasis;
    float margin[FC_Edge_Count];
    float position[FC_Edge_Count];
    float padding[FC_Edge_Count];
    float border[FC_Edge_Count];
    float dimension[FC_Dimension_Count];
    float minDimension[FC_Dimension_Count];
    float maxDimension[FC_Dimension_Count];
    float aspectRatio;
} FCLayoutStyle;

BOOL FCLayoutGetIsRTL(void);
void FCLayoutSetIsRTL(BOOL isRTL);

void FCLayoutStyleInit(FCLayoutStyle *styleRef);
