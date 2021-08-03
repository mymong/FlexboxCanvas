//
//  FCTestViewController01.m
//  FlexboxCanvas
//
//  Created by mymong on 07/22/2021.
//  Copyright (c) 2021 mymong. All rights reserved.
//

#import "FCTestViewController01.h"
#import "FCCanvasView.h"

@interface FCTestViewController01 () <FCCanvasViewDelegate>
@property (nonatomic, readonly) FCCanvasView *canvasView;
@property (nonatomic, readonly) UILabel *testNativeView;
@property (nonatomic, nullable, weak) UIView *testReferenceView;
@end

@implementation FCTestViewController01

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _testNativeView = [UILabel new];
    _testNativeView.text = @"Hello";
    _testNativeView.textAlignment = NSTextAlignmentCenter;
    
    _canvasView = [[FCCanvasView alloc] initWithFrame:self.view.bounds];
    self.canvasView.delegate = self;
    [self.view addSubview:self.canvasView];
    
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

#pragma mark <FCCanvasViewDelegate>

- (nullable UIView *)canvasView:(FCCanvasView *)canvasView nativeViewForKey:(NSString *)key {
    if ([key isEqualToString:@"testNativeView"]) {
        return _testNativeView;
    }
    return nil;
}

- (void)canvasView:(FCCanvasView *)canvasView onEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender {
    if ([event isEqualToString:@"onRef"]) {
        if ([sender isKindOfClass:UIView.class] && [message isEqualToString:@"testReferenceView"]) {
            _testReferenceView = sender;
        }
    }
    else if ([message isEqualToString:@"onBig"]) {
        [self onBig];
    }
    else if ([message isEqualToString:@"onSmall"]) {
        [self onSmall:userInfo];
    }
    else if ([message isEqualToString:@"onRandomColor"]) {
        [self onRandomColor:userInfo sender:sender];
    }
}

@end
