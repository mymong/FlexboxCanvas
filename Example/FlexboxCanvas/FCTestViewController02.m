//
//  FCTestViewController02.m
//  FlexboxCanvas_Example
//
//  Created by Guang Yang on 2021/8/2.
//  Copyright © 2021 mymong. All rights reserved.
//

#import "FCTestViewController02.h"

@interface FCTestViewController02 ()
@property (nonatomic, readonly) UILabel *testNativeView;
@property (nonatomic, nullable, weak) UIView *testReferenceView;
@end

@implementation FCTestViewController02

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _testNativeView = [UILabel new];
    _testNativeView.text = @"Hello";
    _testNativeView.textAlignment = NSTextAlignmentCenter;
    
    [self.canvasView setValue:@"40" forManagedVariable:@"width"];
    [self.canvasView setValue:@"40" forManagedVariable:@"height"];
    [self.canvasView setValue:@"black" forManagedVariable:@"color"];
    
    [self.canvasView loadXMLResource:@"001.xml" inBundle:nil];
}

- (void)onBig {
    [self.canvasView setValue:@"200" forManagedVariable:@"width"];
    [self.canvasView setValue:@"200" forManagedVariable:@"height"];
    self.testReferenceView.backgroundColor = [UIColor brownColor];
}

- (void)onSmall:(NSDictionary *)userInfo {
    [self.canvasView setValue:@"40" forManagedVariable:@"width"];
    [self.canvasView setValue:@"40" forManagedVariable:@"height"];
    self.testReferenceView.backgroundColor = [UIColor orangeColor];
}

- (void)onRandomColor:(NSDictionary *)userInfo sender:(id)sender {
    int r = rand() % 256;
    int g = rand() % 256;
    int b = rand() % 256;
    
//    NSString *string = [NSString stringWithFormat:@"%@,%@,%@", @(r), @(g), @(b)];
//    [self.canvasView setValue:string forManagedVariable:@"color"];
    
    UIView *view = sender;
    view.backgroundColor = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
