//
//  FCComponentLayout.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/23.
//

#import <UIKit/UIKit.h>

@protocol FCLayoutNode;

NS_ASSUME_NONNULL_BEGIN

@protocol FCComponentLayout <NSObject>
- (nullable id<FCLayoutNode>)node;
@property (nonatomic) CGRect frame;
@end

NS_ASSUME_NONNULL_END
