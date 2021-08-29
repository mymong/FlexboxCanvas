//
//  FCImageComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/14.
//

#import "FCImageComponent.h"
#import "FCImageStyle.h"
#import "FCImageProps.h"
#import "FCLayoutNode.h"
#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <SDWebImage/SDImageCache.h>

@interface FCImageComponent () <FCLayoutMeasure>
@property (nonatomic) NSString *lastUri;
@property (nonatomic) CGSize lastSize;
@end

@implementation FCImageComponent

- (instancetype)initWithElement:(FCElement *)element {
    if (self = [super initWithElement:element]) {
        _lastUri = @"";
        _lastSize = CGSizeZero;
    }
    return self;
}

#pragma mark FCViewComponent

- (Class)propsClass {
    return [FCImageProps class];
}

- (Class)managedViewClass {
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
    
    NSString *uri = props.uri ?: @"";
    NSURL *url = [NSURL URLWithString:uri];
    
    if (url && url.scheme.length > 0) {
        __weak __typeof(self) weakSelf = self;
        __weak __typeof(view) weakView = view;
        [view sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            __strong __typeof(weakSelf) self = weakSelf;
            [self onLoadImage:image forURI:uri];
            if (image) {
                __strong __typeof(weakView) view = weakView;
                if (style.tintColor && image && image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                    view.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                }
            }
        }];
    }
    else {
        UIImage *image = [UIImage imageNamed:uri];
        [self onLoadImage:image forURI:uri];
        if (image) {
            if (style.tintColor && image.renderingMode != UIImageRenderingModeAlwaysTemplate) {
                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
        }
        view.image = image;
    }
}

#pragma mark <FCLayoutMeasure>

- (CGSize)measureInSize:(CGSize)size widthMode:(FCLayoutMeasureMode)widthMode heightMode:(FCLayoutMeasureMode)heightMode {
    CGSize newSize = [self contentSizeThatFits:size];
//    newSize.width += FCRoundPixelValue(0.1);
//    newSize.height += FCRoundPixelValue(0.1);
    if (FCLayoutMeasureModeExactly == widthMode) {
        newSize.width = size.width;
    }
    if (FCLayoutMeasureModeExactly == heightMode) {
        newSize.height = size.height;
    }
    return newSize;
}

#pragma mark Private

- (CGSize)contentSizeThatFits:(CGSize)size {
    CGSize imageSize = [self cachedImageSize];
    
    if (size.width > imageSize.width) {
        size.width = imageSize.width;
    }
    if (size.height > imageSize.height) {
        size.height = imageSize.height;
    }
    
    if (imageSize.width > 0) {
        CGFloat height = size.width / imageSize.width * imageSize.height;
        if (size.height > height) {
            size.height = height;
        }
    }
    if (imageSize.height > 0) {
        CGFloat width = size.height / imageSize.height * imageSize.width;
        if (size.width > width) {
            size.width = width;
        }
    }
    if (imageSize.width > 0) {
        CGFloat height = size.width / imageSize.width * imageSize.height;
        if (size.height > height) {
            size.height = height;
        }
    }
    
//    size.width = FCRoundPixelValue(size.width);
//    size.height = FCRoundPixelValue(size.height);
    return size;
}

- (void)onLoadImage:(UIImage *)image forURI:(NSString *)uri {
    CGSize oldSize = CGSizeZero;
    if ([uri isEqualToString:self.lastUri]) {
        oldSize = self.lastSize;
    }
    
    CGSize newSize = CGSizeZero;
    if (image) {
        newSize = image.size;
    }
    
    self.lastUri = uri;
    self.lastSize = newSize;
    
    if (!CGSizeEqualToSize(oldSize, newSize)) {
        [self.node markDirty];
        [self notifyWaitingDirty];
    }
}

- (CGSize)cachedImageSize {
    FCImageProps *props = self.props;
    NSString *uri = props.uri ?: @"";
    
    if (![uri isEqualToString:self.lastUri]) {
        CGSize size = CGSizeZero;
        if (uri) {
            UIImage *image = [[SDImageCache sharedImageCache] imageFromCacheForKey:uri];
            if (image) {
                size = [image size];
            }
        }
        self.lastUri = uri;
        self.lastSize = size;
    }
    
    return self.lastSize;
}

@end
