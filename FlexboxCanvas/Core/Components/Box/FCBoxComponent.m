//
//  FCBoxComponent.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/22.
//

#import "FCBoxComponent.h"
#import "FCLayoutNode.h"

@implementation FCBoxComponent {
    id<FCLayoutNode> _node;
    CGRect _frame;
}

#pragma mark Overriden

- (instancetype)initWithElement:(FCElement *)element {
    if (self = [super initWithElement:element]) {
        _node = [FCLayoutNodeFactory node];
    }
    return self;
}

- (void)applyLayoutStyle:(nullable NSDictionary *)style {
    [_node applyStyle:style];
}

- (void)linkLayoutTree {
    NSArray<FCComponent *> *children = self.children;
    if (children) {
        NSMutableArray *subnodes = [NSMutableArray new];
        for (FCComponent *child in children) {
            id<FCLayoutNode> subnode = child.node;
            if (subnode) {
                [subnodes addObject:child.node];
            }
        }
        [_node setSubnodes:subnodes];
    } else {
        [_node setSubnodes:nil];
    }
}

- (void)frameChildren {
    CGPoint origin = self.frame.origin;
    for (FCComponent *child in self.children) {
        id<FCLayoutNode> node = child.node;
        if (node) {
            CGRect frame = node.frame;
            frame.origin.x += origin.x;
            frame.origin.y += origin.y;
            child.frame = frame;
        }
    }
}

#pragma mark <FCComponentLayout>

- (id<FCLayoutNode>)node {
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
