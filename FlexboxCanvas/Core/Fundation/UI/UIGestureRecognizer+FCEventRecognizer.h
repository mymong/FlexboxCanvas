//
//  UIGestureRecognizer+FCEventRecognizer.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/1.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIGestureRecognizer (FCEventRecognizer)
@property (nonatomic) NSString *fc_event;
@property (nonatomic) NSString *fc_message;
@end

NS_ASSUME_NONNULL_END
