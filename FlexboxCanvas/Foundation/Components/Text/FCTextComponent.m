//
//  FCTextComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import "FCTextComponent.h"
#import "FCTextView.h"
#import "FCTextProps.h"
#import "FCTextStyle.h"
#import "FC_Node.h"

static CGFloat FCRoundPixelValue(CGFloat value) {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        scale = [UIScreen mainScreen].scale;
    });
    return ceilf(value * scale) / scale;
}

@interface FCTextComponent () <FC_Measurer>

@end

@implementation FCTextComponent

- (Class)propsClass {
    return [FCTextProps class];
}

#pragma mark FCViewComponent

- (Class)viewClass {
    return [FCTextView class];
}

- (void)managedView:(FCTextView *)view applyProps:(FCTextProps *)props {
    [super managedView:view applyProps:props];
    
    NSAttributedString *text = [self makeAttributedText:props];
    [view setAttributedText:text];
    
    FCTextStyle *style = [props style];
    NSParameterAssert(style);
    
    if (style) {
        view.numberOfLines = style.numberOfLines;
        view.contentInsets = [style contentInsets];
    }
}

#pragma mark <FC_Measurer>

- (CGSize)measureInSize:(CGSize)size widthMode:(FC_MeasurerMode)widthMode heightMode:(FC_MeasurerMode)heightMode {
    CGSize newSize = [self contentSizeThatFits:size];
//    newSize.width += FCRoundPixelValue(0.1);
//    newSize.height += FCRoundPixelValue(0.1);
    if (FC_MeasurerMode_Exactly == widthMode) {
        newSize.width = size.width;
    }
    if (FC_MeasurerMode_Exactly == heightMode) {
        newSize.height = size.height;
    }
    return newSize;
}

#pragma mark Private

- (CGSize)contentSizeThatFits:(CGSize)size {
    NSAttributedString *attributedText = [self makeAttributedText:self.props];
    if (!attributedText || 0 == attributedText.length) {
        return CGSizeZero;
    }
    size = [attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine context:NULL].size;
    size.width = FCRoundPixelValue(size.width);
    size.height = FCRoundPixelValue(size.height);
    return size;
}

- (NSAttributedString *)makeAttributedText:(FCTextProps *)props {
    FCTextStyle *style = [props style];
    NSParameterAssert(style);
    
    NSString *text = [props text];
    if (!text || 0 == text.length) {
        return nil;
    }

    NSMutableDictionary *attributes = [NSMutableDictionary new];
    
    // font
    
    attributes[NSFontAttributeName] = [style textFont];
    
    // color
    
    UIColor *textColor = [style textColor];
    if (textColor) {
        attributes[NSForegroundColorAttributeName] = textColor;
    }
    
    // paragraph
    
    NSMutableParagraphStyle *paragraphStyle;
    
    NSTextAlignment textAlign = [style textAlign];
    if (textAlign != NSTextAlignmentNatural) {
        paragraphStyle = paragraphStyle ?: [NSMutableParagraphStyle new];
        paragraphStyle.alignment = textAlign;
    }
    
    NSLineBreakMode lineBreak = [style lineBreak];
    if (lineBreak != NSLineBreakByWordWrapping) {
        paragraphStyle = paragraphStyle ?: [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = lineBreak;
    }
    
    if (paragraphStyle) {
        attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    }

    // shadow
    
    NSShadow *shadow;
    
    UIColor *shadowColor = [style textShadowColor];
    if (shadowColor) {
        shadow = shadow ?: [NSShadow new];
        shadow.shadowColor = shadowColor;
    }
    
    CGSize shadowOffset = [style textShadowOffset];
    if (!CGSizeEqualToSize(shadowOffset, CGSizeZero)) {
        shadow = shadow ?: [NSShadow new];
        shadow.shadowOffset = shadowOffset;
    }
    
    float shadowBlurRadius = [style textShadowRadius];
    if (shadowBlurRadius > 0) {
        shadow = shadow ?: [NSShadow new];
        shadow.shadowBlurRadius = shadowBlurRadius;
    }
    
    if (shadow) {
        attributes[NSShadowAttributeName] = shadow;
    }
    
    // link
    NSString *link = [props link];
    if (link && link.length > 0) {
        attributes[NSLinkAttributeName] = link;
    }
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

@end
