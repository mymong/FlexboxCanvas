//
//  FCBoxComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/22.
//

#import "FCBoxComponent.h"
#import "FCBoxProps.h"
#import "FC_Node.h"

@implementation FCBoxComponent {
    id<FC_Node> _node;
    CGRect _frame;
}

- (Class)propsClass {
    return [FCBoxProps class];
}

#pragma mark Overriden

- (instancetype)initWithElement:(FCElement *)element {
    if (self = [super initWithElement:element]) {
        _node = [FC_Node node];
        if ([self conformsToProtocol:@protocol(FC_Measurer)]) {
            [_node setMeasurer:(id)self];
        }
    }
    return self;
}

- (void)startNode {
    FCBoxProps *props = [self props];
    [_node setStyle:props.style.styleRef];
}

- (void)linkSubnodes {
    NSArray<FCComponent *> *children = self.children;
    if (children) {
        NSMutableArray *subnodes = [NSMutableArray new];
        for (FCComponent *child in children) {
            id<FC_Node> subnode = child.node;
            if (subnode) {
                [subnodes addObject:child.node];
            }
        }
        [_node setSubnodes:subnodes];
    } else {
        [_node setSubnodes:nil];
    }
}

- (void)finishNode {
    CGPoint origin = self.frame.origin;
    for (FCComponent *child in self.children) {
        id<FC_Node> node = child.node;
        if (node) {
            CGRect frame = node.frame;
            frame.origin.x += origin.x;
            frame.origin.y += origin.y;
            child.frame = frame;
        }
    }
}

#pragma mark <FCComponentLayout>

- (id<FC_Node>)node {
    return _node;
}

- (CGRect)frame {
    return _frame;
}

- (void)setFrame:(CGRect)frame {
    if (!CGRectEqualToRect(_frame, frame)) {
        _frame = frame;
        [self notifyPendingDirty];
    }
}

@end
