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

@implementation FCTextComponent

- (Class)propsClass {
    return [FCTextProps class];
}

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

- (void)startNode {
    [super startNode];
}

- (NSUInteger)secondLayoutHierachy {
    FCTextProps *props = [self props];
    FCTextStyle *style = [props style];
    FCTextSizeMode sizeMode = style.sizeMode;
    
    if (FCTextSizeModeFitWidth == sizeMode) {
        CGSize styleSize = CGSizeMake(NAN, NAN);
        [style getDimensions:&styleSize];
        if (!isnan(styleSize.height)) {
            return 0;
        }
        
        UIEdgeInsets contentInsets = [style contentInsets];
        CGSize layoutSize = [self.node frame].size;
        if (layoutSize.width <= contentInsets.left + contentInsets.right) {
            return 0;
        }
        
        CGSize secondSize = CGSizeMake(layoutSize.width, CGFLOAT_MAX);
        secondSize = [self sizeThatFits:secondSize contentInsets:contentInsets];
        secondSize.width = layoutSize.width;
        secondSize.height += FCRoundPixelValue(0.1);
        [self.node setStyleSize:secondSize];
        return 1;
    }
    else if (FCTextSizeModeFitHeight == sizeMode) {
        CGSize styleSize = CGSizeMake(NAN, NAN);
        [style getDimensions:&styleSize];
        if (!isnan(styleSize.width)) {
            return 0;
        }
        
        UIEdgeInsets contentInsets = [style contentInsets];
        CGSize layoutSize = [self.node frame].size;
        if (layoutSize.height <= contentInsets.top + contentInsets.bottom) {
            return 0;
        }
        
        CGSize secondSize = CGSizeMake(CGFLOAT_MAX, layoutSize.height);
        secondSize = [self sizeThatFits:secondSize contentInsets:contentInsets];
        secondSize.height = layoutSize.height;
        [self.node setStyleSize:secondSize];
        return 1;
    }
    
    return 0;
}

- (CGSize)sizeThatFits:(CGSize)size contentInsets:(UIEdgeInsets)contentInsets {
    NSAttributedString *attributedText = [self makeAttributedText:self.props];
    if (!attributedText || 0 == attributedText.length) {
        return CGSizeZero;
    }
    UIEdgeInsets insets = contentInsets;
    size.width -= insets.left + insets.right;
    size.height -= insets.top + insets.bottom;
    size = [attributedText boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine context:NULL].size;
    size.width = FCRoundPixelValue(size.width);
    size.height = FCRoundPixelValue(size.height);
    size.width += insets.left + insets.right;
    size.height += insets.top + insets.bottom;
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
