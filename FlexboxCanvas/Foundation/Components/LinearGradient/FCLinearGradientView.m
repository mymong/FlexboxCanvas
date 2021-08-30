//
//  FCLinearGradientView.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCLinearGradientView.h"

@implementation FCLinearGradientView {
    CAGradientLayer *_gradientLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer new];
        [self.layer addSublayer:_gradientLayer];
    }
    
    CGRect frame = self.bounds;
    if (!CGRectEqualToRect(_gradientLayer.frame, frame)) {
        _gradientLayer.frame = self.bounds;
    }
    
    _gradientLayer.startPoint = _startPoint;
    _gradientLayer.endPoint = _endPoint;
    _gradientLayer.locations = _locations;
    _gradientLayer.colors = ({
        NSMutableArray *array = [NSMutableArray new];
        for (NSUInteger i = 0; i < _locations.count; i ++) {
            UIColor *color = (i < _colors.count) ? _colors[i] : [UIColor clearColor];
            [array addObject:(__bridge id)color.CGColor];
        }
        array;
    });
}

@end
