//
//  FCTestViewController.m
//  FlexboxCanvas_Example
//
//  Created by Guang Yang on 2021/8/2.
//  Copyright © 2021 mymong. All rights reserved.
//

#import "FCTestViewController.h"

@interface FCTestViewController ()
@property (nonatomic, readonly) UILabel *nativeLabelView;
@property (nonatomic, nullable, weak) UIView *refSizingView;
@end

@implementation FCTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _nativeLabelView = [UILabel new];
    _nativeLabelView.text = @"Native Label";
    _nativeLabelView.textAlignment = NSTextAlignmentCenter;
    
    [self.canvasView setValue:@"120" forManagedVariable:@"width"];
    [self.canvasView setValue:@"40" forManagedVariable:@"height"];
    [self.canvasView setValue:@"pink" forManagedVariable:@"color"];
    
    [self.canvasView loadXMLResource:@"test.xml" inBundle:nil];
}

// onRef
- (void)setRefSizingView:(UIView *)sizeChangeView {
    _refSizingView = sizeChangeView;
    if (sizeChangeView) {
        UILabel *label = sizeChangeView.subviews.firstObject;
        if (!label) {
            label = [[UILabel alloc] initWithFrame:sizeChangeView.bounds];
            label.text = @"Long press me";
            label.textAlignment = NSTextAlignmentCenter;
            [sizeChangeView addSubview:label];
        }
    }
}

- (void)onBig {
    [self.canvasView setValue:@"200" forManagedVariable:@"width"];
    [self.canvasView setValue:@"200" forManagedVariable:@"height"];
    self.refSizingView.backgroundColor = [UIColor brownColor];
    UILabel *label = self.refSizingView.subviews.firstObject;
    if (label) {
        label.text = @"Click me";
        label.frame = CGRectMake(0, 0, 200, 200);
    }
}

- (void)onSmall:(NSDictionary *)userInfo {
    [self.canvasView setValue:@"120" forManagedVariable:@"width"];
    [self.canvasView setValue:@"40" forManagedVariable:@"height"];
    self.refSizingView.backgroundColor = [UIColor orangeColor];
    UILabel *label = self.refSizingView.subviews.firstObject;
    if (label) {
        label.text = @"Long press me";
        label.frame = CGRectMake(0, 0, 120, 40);
    }
}

- (void)onRandomColor:(NSDictionary *)userInfo sender:(id)sender {
    int r = rand() % 256;
    int g = rand() % 256;
    int b = rand() % 256;
    
    NSString *string = [NSString stringWithFormat:@"%@,%@,%@", @(r), @(g), @(b)];
    [self.canvasView setValue:string forManagedVariable:@"color"];
}

@end
