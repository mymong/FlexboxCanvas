//
//  FCImageComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/14.
//

#import "FCImageComponent.h"
#import "FCImageStyle.h"
#import "FCImageProps.h"
#import "FC_Node.h"
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>

@implementation FCImageComponent

#pragma mark FCViewComponent

- (Class)propsClass {
    return [FCImageProps class];
}

- (Class)viewClass {
    return [UIImageView class];
}

- (void)managedView:(UIImageView *)view applyProps:(FCImageProps *)props {
    [super managedView:view applyProps:props];
    
    FCImageStyle *style = [props style];
    NSParameterAssert(style);
    
    if (style) {
        view.contentMode = style.contentMode;
        view.tintColor = style.tintColor;
    }
    
    NSString *uri = props.uri;
    if (uri && uri.length > 0) {
        NSURL *url = [NSURL URLWithString:uri];
        if (url.scheme.length > 0) {
            __weak __typeof(self) weakSelf = self;
            __weak __typeof(view) weakView = view;
            [view sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (image) {
                    __strong __typeof(weakSelf) self = weakSelf;
                    if (self && image) {
                        [self onLoadImage:image forURI:uri];
                    }
                    __strong __typeof(weakView) view = weakView;
                    if (style.tintColor && image && image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                        view.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                    }
                }
            }];
        }
        else {
            UIImage *image = [UIImage imageNamed:uri];
            if (image) {
                [self onLoadImage:image forURI:uri];
                if (style.tintColor && image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                }
            }
            view.image = image;
        }
    } else {
        view.image = nil;
    }
}

- (void)onLoadImage:(UIImage *)image forURI:(NSString *)uri {
    FCImageProps *props = [self props];
    FCImageStyle *style = [props style];
    FC_Style *styleRef = style.styleRef;
    if (styleRef && isnan(styleRef->aspectRatio)) {
        if (isnan(styleRef->dimension[FC_Dimension_Width]) || isnan(styleRef->dimension[FC_Dimension_Height])) {
            CGSize size = image.size;
            if (size.width > 0 && size.height > 0) {
                float aspectRatio = size.width / size.height;
                if (aspectRatio != [self.node aspectRatio]) {
                    [self.node setAspectRatio:aspectRatio];
                    [self notifyWaitingDirty];
                }
            }
        }
    }
}

@end
