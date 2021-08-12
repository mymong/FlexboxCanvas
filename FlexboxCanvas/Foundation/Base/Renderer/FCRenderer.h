//
//  FCRenderer.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/26.
//

#import <Foundation/Foundation.h>

@class UIView;
@class FCElement;
@protocol FCCanvas;

NS_ASSUME_NONNULL_BEGIN

@interface FCRenderer : NSObject
@property (nonatomic, weak, nullable) id<FCCanvas> canvas;
- (instancetype)initWithView:(UIView *)view;
- (void)loadWithElement:(nullable FCElement *)element;
- (void)render;
@end

NS_ASSUME_NONNULL_END
