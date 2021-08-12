//
//  FCCanvasViewController.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/2.
//

#import "FCCanvasView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCCanvasViewController : UIViewController <FCCanvasViewDelegate>
@property (nonatomic, readonly) FCCanvasView *canvasView;
- (BOOL)openURL:(NSURL *)url withEvent:(NSString *)event userInfo:(nullable NSDictionary *)userInfo sender:(id)sender;
@end

NS_ASSUME_NONNULL_END
