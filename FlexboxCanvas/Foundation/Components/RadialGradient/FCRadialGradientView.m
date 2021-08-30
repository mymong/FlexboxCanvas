//
//  FCRadialGradientView.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/30.
//

#import "FCRadialGradientView.h"

@implementation FCRadialGradientView {
    FCRadialGradientLayer *_gradientLayer;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_gradientLayer) {
        _gradientLayer = [FCRadialGradientLayer new];
        [self.layer addSublayer:_gradientLayer];
    }
    
    CGRect frame = self.bounds;
    if (!CGRectEqualToRect(_gradientLayer.frame, frame)) {
        _gradientLayer.frame = self.bounds;
    }
    
    if (_colors.count != _locations.count) {
        NSMutableArray *colors = [NSMutableArray new];
        for (NSUInteger i = 0; i < _locations.count; i ++) {
            if (i < _colors.count) {
                [colors addObject:_colors[i]];
            } else {
                [colors addObject:UIColor.clearColor];
            }
        }
        _colors = colors;
    }
    
    _gradientLayer.centerPoint = _centerPoint;
    _gradientLayer.startRadius = _startRadius;
    _gradientLayer.endRadius = _endRadius;
    _gradientLayer.locations = _locations;
    _gradientLayer.colors = ({
        NSMutableArray *array = [NSMutableArray new];
        for (UIColor *color in _colors) {
            [array addObject:(__bridge id)color.CGColor];
        }
        array;
    });
}

@end

@implementation FCRadialGradientLayer

- (instancetype)init {
    if (self = [super init]) {
        [self setNeedsDisplay];
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    NSParameterAssert(_colors.count == _locations.count);
    
    CGFloat *locations = malloc(sizeof(CGFloat) * _locations.count);
    for (NSUInteger i = 0; i < _locations.count; i ++) {
        locations[i] = [_locations[i] floatValue];
    }
    
    CGSize size = self.frame.size;
    CGPoint centerPoint = CGPointMake(size.width * _centerPoint.x, size.height * _centerPoint.y);
    
    CGFloat diagonalLength = sqrtf(size.width * size.width + size.height * size.height);
    CGFloat startRadius = diagonalLength * _startRadius;
    CGFloat endRadius = diagonalLength * _endRadius;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)_colors, locations);
    CGContextDrawRadialGradient(ctx, gradient, centerPoint, startRadius, centerPoint, endRadius, kCGGradientDrawsAfterEndLocation);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    free(locations);
}

@end
