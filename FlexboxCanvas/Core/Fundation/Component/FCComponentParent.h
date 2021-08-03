//
//  FCComponentParent.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/23.
//

#import <Foundation/Foundation.h>

@protocol FCCanvas;
@class UIView;

NS_ASSUME_NONNULL_BEGIN

@protocol FCComponentParent <NSObject>
- (UIView *)view;
- (id<FCCanvas>)canvas;
- (void)notifyWaitingDirty;
- (void)notifyPendingDirty;
@end

NS_ASSUME_NONNULL_END
