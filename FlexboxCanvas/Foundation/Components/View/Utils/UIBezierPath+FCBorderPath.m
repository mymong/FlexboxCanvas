//
//  UIBezierPath+FCBorderPath.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/31.
//

#import "UIBezierPath+FCBorderPath.h"

@implementation UIBezierPath (FCBorderPath)

+ (instancetype)fc_bezierPathWithRect:(CGRect)rect radius:(CGSize)radius corners:(UIRectCorner)corners {
    if (radius.width <= 0 || radius.height <= 0) {
        return [self bezierPathWithRect:rect];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint ctl = rect.origin;
    if (corners & UIRectCornerTopLeft) {
        CGPoint l1 = CGPointMake(rect.origin.x, rect.origin.y + radius.height);
        CGPoint t0 = CGPointMake(rect.origin.x + radius.width, rect.origin.y);
        [path moveToPoint:l1];
        [path addQuadCurveToPoint:t0 controlPoint:ctl];
    } else {
        [path moveToPoint:ctl];
    }
    
    ctl.x = rect.origin.x + rect.size.width;
    if (corners & UIRectCornerTopRight) {
        CGPoint t1 = CGPointMake(rect.origin.x + rect.size.width - radius.width, rect.origin.y);
        CGPoint r0 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + radius.height);
        [path addLineToPoint:t1];
        [path addQuadCurveToPoint:r0 controlPoint:ctl];
    } else {
        [path addLineToPoint:ctl];
    }
    
    ctl.y = rect.origin.y + rect.size.height;
    if (corners & UIRectCornerBottomRight) {
        CGPoint r1 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius.height);
        CGPoint b0 = CGPointMake(rect.origin.x + rect.size.width - radius.width, rect.origin.y + rect.size.height);
        [path addLineToPoint:r1];
        [path addQuadCurveToPoint:b0 controlPoint:ctl];
    } else {
        [path addLineToPoint:ctl];
    }
    
    ctl.x = rect.origin.x;
    if (corners & UIRectCornerBottomLeft) {
        CGPoint b1 = CGPointMake(rect.origin.x + radius.width, rect.origin.y + rect.size.height);
        CGPoint l0 = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - radius.height);
        [path addLineToPoint:b1];
        [path addQuadCurveToPoint:l0 controlPoint:ctl];
    } else {
        [path addLineToPoint:ctl];
    }
    
    ctl.y = rect.origin.y;
    if (corners & UIRectCornerTopLeft) {
        CGPoint l1 = CGPointMake(rect.origin.x, rect.origin.y +radius.height);
        [path addLineToPoint:l1];
    } else {
        [path addLineToPoint:ctl];
    }
    
    return path;
}

+ (instancetype)fc_bezierPathWithRect:(CGRect)rect thorn:(CGSize)thorn edge:(FCBorderThornEdge)edge location:(CGFloat)location {
    if (thorn.width <= 0 || thorn.height <= 0) {
        return [self bezierPathWithRect:rect];
    }
    
    CGPoint pp, pa, pb;
    edge = [self fc_calculatePointsWithRect:rect thorn:thorn edge:edge location:location pp:&pp pa:&pa pb:&pb];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint ctl = rect.origin;
    [path moveToPoint:ctl];
    if (edge == FCBorderThornEdgeTop) {
        [path addLineToPoint:pa];
        [path addLineToPoint:pp];
        [path addLineToPoint:pb];
    }
    ctl.x = rect.origin.x + rect.size.width;
    [path addLineToPoint:ctl];
    if (edge == FCBorderThornEdgeRight) {
        [path addLineToPoint:pa];
        [path addLineToPoint:pp];
        [path addLineToPoint:pb];
    }
    ctl.y = rect.origin.y + rect.size.height;
    [path addLineToPoint:ctl];
    if (edge == FCBorderThornEdgeBottom) {
        [path addLineToPoint:pa];
        [path addLineToPoint:pp];
        [path addLineToPoint:pb];
    }
    ctl.x = rect.origin.x;
    [path addLineToPoint:ctl];
    if (edge == FCBorderThornEdgeLeft) {
        [path addLineToPoint:pa];
        [path addLineToPoint:pp];
        [path addLineToPoint:pb];
    }
    ctl.y = rect.origin.y;
    [path addLineToPoint:ctl];
    return path;
}

+ (instancetype)fc_bezierPathWithRect:(CGRect)rect radius:(CGSize)radius corners:(UIRectCorner)corners thorn:(CGSize)thorn edge:(FCBorderThornEdge)edge location:(CGFloat)location {
    if (thorn.width <= 0 || thorn.height <= 0) {
        return [self fc_bezierPathWithRect:rect radius:radius corners:corners];
    }
    if (radius.width <= 0 || radius.height <= 0) {
        return [self fc_bezierPathWithRect:rect thorn:thorn edge:edge location:location];
    }
    
    CGPoint pp, pa, pb;
    edge = [self fc_calculatePointsWithRect:rect thorn:thorn edge:edge location:location pp:&pp pa:&pa pb:&pb];
    
    CGPoint t0 = CGPointMake(rect.origin.x + radius.width, rect.origin.y);
    CGPoint t1 = CGPointMake(rect.origin.x + rect.size.width - radius.width, rect.origin.y);
    CGPoint r0 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + radius.height);
    CGPoint r1 = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height - radius.height);
    CGPoint b0 = CGPointMake(rect.origin.x + rect.size.width - radius.width, rect.origin.y + rect.size.height);
    CGPoint b1 = CGPointMake(rect.origin.x + radius.width, rect.origin.y + rect.size.height);
    CGPoint l0 = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height - radius.height);
    CGPoint l1 = CGPointMake(rect.origin.x, rect.origin.y + radius.height);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint ctl = rect.origin;
    if (corners & UIRectCornerTopLeft) {
        if (edge == FCBorderThornEdgeLeft && pb.y < l1.y) {
            [path moveToPoint:pb];
        } else {
            [path moveToPoint:l1];
        }
        if (edge == FCBorderThornEdgeTop) {
            if (pa.x <= t0.x) {
                [path addQuadCurveToPoint:pa controlPoint:ctl];
            } else {
                [path addQuadCurveToPoint:t0 controlPoint:ctl];
                [path addLineToPoint:pa];
            }
            [path addLineToPoint:pp];
            [path addLineToPoint:pb];
        } else {
            [path addQuadCurveToPoint:t0 controlPoint:ctl];
        }
    } else {
        [path moveToPoint:ctl];
        if (edge == FCBorderThornEdgeTop) {
            [path addLineToPoint:pa];
            [path addLineToPoint:pp];
            [path addLineToPoint:pb];
        }
    }
    
    ctl.x = rect.origin.x + rect.size.width;
    if (corners & UIRectCornerTopRight) {
        if (t1.x > path.currentPoint.x) {
            [path addLineToPoint:t1];
        }
        if (edge == FCBorderThornEdgeRight) {
            if (pa.y <= r0.y) {
                [path addQuadCurveToPoint:pa controlPoint:ctl];
            } else {
                [path addQuadCurveToPoint:r0 controlPoint:ctl];
                [path addLineToPoint:pa];
            }
            [path addLineToPoint:pp];
            [path addLineToPoint:pb];
        } else {
            [path addQuadCurveToPoint:r0 controlPoint:ctl];
        }
    } else {
        [path addLineToPoint:ctl];
        if (edge == FCBorderThornEdgeRight) {
            [path addLineToPoint:pa];
            [path addLineToPoint:pp];
            [path addLineToPoint:pb];
        }
    }
    
    ctl.y = rect.origin.y + rect.size.height;
    if (corners & UIRectCornerBottomRight) {
        if (r1.y > path.currentPoint.y) {
            [path addLineToPoint:r1];
        }
        if (edge == FCBorderThornEdgeBottom) {
            if (pa.x >= b0.x) {
                [path addQuadCurveToPoint:pa controlPoint:ctl];
            } else {
                [path addQuadCurveToPoint:b0 controlPoint:ctl];
                [path addLineToPoint:pa];
            }
            [path addLineToPoint:pp];
            [path addLineToPoint:pb];
        } else {
            [path addQuadCurveToPoint:b0 controlPoint:ctl];
        }
    } else {
        [path addLineToPoint:ctl];
        if (edge == FCBorderThornEdgeBottom) {
            [path addLineToPoint:pa];
            [path addLineToPoint:pp];
            [path addLineToPoint:pb];
        }
    }
    
    ctl.x = rect.origin.x;
    if (corners & UIRectCornerBottomLeft) {
        if (b1.x < path.currentPoint.x) {
            [path addLineToPoint:b1];
        }
        if (edge == FCBorderThornEdgeLeft) {
            if (pa.y >= l0.y) {
                [path addQuadCurveToPoint:pa controlPoint:ctl];
            } else {
                [path addQuadCurveToPoint:l0 controlPoint:ctl];
                [path addLineToPoint:pa];
            }
            [path addLineToPoint:pp];
            [path addLineToPoint:pb];
        } else {
            [path addQuadCurveToPoint:l0 controlPoint:ctl];
        }
    } else {
        [path addLineToPoint:ctl];
        if (edge == FCBorderThornEdgeBottom) {
            [path addLineToPoint:pa];
            [path addLineToPoint:pp];
            [path addLineToPoint:pb];
        }
    }
    
    [path closePath];
    return path;
}

+ (instancetype)fc_thornPathWithRect:(CGRect)rect thorn:(CGSize)thorn edge:(FCBorderThornEdge)edge location:(CGFloat)location {
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (thorn.width > 0 && thorn.height > 0) {
        CGPoint pp, pa, pb;
        [self fc_calculatePointsWithRect:rect thorn:thorn edge:edge location:location pp:&pp pa:&pa pb:&pb];
        [path moveToPoint:pa];
        [path addLineToPoint:pp];
        [path addLineToPoint:pb];
        [path closePath];
    }
    return path;
}

+ (FCBorderThornEdge)fc_calculatePointsWithRect:(CGRect)rect thorn:(CGSize)thorn edge:(FCBorderThornEdge)edge location:(CGFloat)location pp:(CGPoint *)pp pa:(CGPoint *)pa pb:(CGPoint *)pb {
    
    CGPoint p, a, b;
    switch (edge) {
        case FCBorderThornEdgeLeft: {
            p.x = 0 - thorn.height;
            p.y = rect.size.height * location;
            if (p.y < 0) {
                p.y = 0;
            }
            if (p.y > rect.size.height) {
                p.y = rect.size.height;
            }
            
            a.x = 0;
            a.y = p.y + thorn.width / 2;
            if (a.y > rect.size.height) {
                a.y = rect.size.height;
            }
            
            b.x = 0;
            b.y = p.y - thorn.height / 2;
            if (b.y < 0) {
                b.y = 0;
            }
            
            break;
        }
        case FCBorderThornEdgeTop: {
            p.x = rect.size.width * location;
            if (p.x < 0) {
                p.x = 0;
            }
            if (p.x > rect.size.width) {
                p.x = rect.size.width;
            }
            p.y = 0 - thorn.height;
            
            a.x = p.x - thorn.width / 2;
            if (a.x < 0) {
                a.x = 0;
            }
            a.y = 0;
            
            b.x = p.x + thorn.width / 2;
            if (b.x > rect.size.width) {
                b.x = rect.size.width;
            }
            b.y = 0;
            
            break;
        }
        case FCBorderThornEdgeRight: {
            p.x = rect.size.width + thorn.height;
            p.y = rect.size.height * location;
            if (p.y < 0) {
                p.y = 0;
            }
            if (p.y > rect.size.height) {
                p.y = rect.size.height;
            }
            
            a.x = rect.size.width;
            a.y = p.y - thorn.width / 2;
            if (a.y < 0) {
                a.y = 0;
            }
            
            b.x = rect.size.width;
            b.y = p.y + thorn.height / 2;
            if (b.y > rect.size.height) {
                b.y = rect.size.height;
            }
            
            break;
        }
        case FCBorderThornEdgeBottom:
        default: {
            p.x = rect.size.width * location;
            if (p.x < 0) {
                p.x = 0;
            }
            if (p.x > rect.size.width) {
                p.x = rect.size.width;
            }
            p.y = rect.size.height + thorn.height;
            
            a.x = p.x + thorn.width / 2;
            if (a.x > rect.size.width) {
                a.x = rect.size.width;
            }
            a.y = rect.size.height;
            
            b.x = p.x - thorn.width / 2;
            if (b.x < 0) {
                b.x = 0;
            }
            b.y = rect.size.height;
            
            edge = FCBorderThornEdgeBottom;
            break;
        }
    }
    
    p.x += rect.origin.x;
    p.y += rect.origin.y;
    a.x += rect.origin.x;
    a.y += rect.origin.y;
    b.x += rect.origin.x;
    b.y += rect.origin.y;
    
    *pp = p;
    *pa = a;
    *pb = b;
    return edge;
}

@end
