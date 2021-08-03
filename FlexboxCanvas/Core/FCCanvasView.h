//
//  FCCanvasView.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import <UIKit/UIKit.h>

@class FCCanvasView;

NS_ASSUME_NONNULL_BEGIN

@protocol FCCanvasViewDelegate <NSObject>
- (nullable UIView *)canvasView:(FCCanvasView *)canvasView nativeViewForKey:(NSString *)key;
- (void)canvasView:(FCCanvasView *)canvasView onEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender;
@end

@protocol FCCanvasViewVariableSource <NSObject>
- (nullable NSString *)canvasView:(FCCanvasView *)canvasView variableValueForName:(NSString *)name;
@end

@interface FCCanvasView : UIView
@property (nonatomic, weak, nullable) id<FCCanvasViewDelegate> delegate;
- (BOOL)loadXMLString:(NSString *)string;
- (BOOL)loadXMLResource:(NSString *)name inBundle:(nullable NSBundle *)bundle;
- (void)setValue:(nullable NSString *)value forManagedVariable:(NSString *)name;
- (nullable NSString *)valueForManagedVariable:(NSString *)name;
@property (nonatomic, weak, nullable) id<FCCanvasViewVariableSource> variableSource;
- (void)dispatchVariableChangeForName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
