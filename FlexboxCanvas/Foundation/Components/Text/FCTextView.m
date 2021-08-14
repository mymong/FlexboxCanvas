//
//  FCTextView.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/10.
//

#import "FCTextView.h"

@implementation FCTextView

- (void)setContentInsets:(UIEdgeInsets)contentInsets {
    if (!UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets)) {
        _contentInsets = contentInsets;
        [self setNeedsLayout];
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    UIEdgeInsets insets = self.contentInsets;
    size.width -= (insets.left + insets.right);
    size.height -= (insets.top + insets.bottom);
    size = [super sizeThatFits:size];
    size.width += (insets.left + insets.right);
    size.height += (insets.top + insets.bottom);
    return size;
}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = self.contentInsets;
    CGRect client = UIEdgeInsetsInsetRect(rect, insets);
    [super drawTextInRect:client];
}

@end
