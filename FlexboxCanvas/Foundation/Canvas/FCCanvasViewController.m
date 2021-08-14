//
//  FCCanvasViewController.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/8/2.
//

#import "FCCanvasViewController.h"

@interface FCCanvasViewController ()
@end

@implementation FCCanvasViewController

- (void)loadView {
    FCCanvasView *canvasView = [FCCanvasView new];
    canvasView.delegate = self;
    self.view = canvasView;
}

- (FCCanvasView *)canvasView {
    return (FCCanvasView *)self.view;
}

- (BOOL)openURL:(NSURL *)url withEvent:(NSString *)event userInfo:(nullable NSDictionary *)userInfo sender:(id)sender {
    // To be overriden
    NSLog(@"Should open url: %@", url);
    return NO;
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}

#pragma mark <FCCanvasViewDelegate>

- (nullable UIView *)canvasView:(FCCanvasView *)canvasView nativeViewForKey:(NSString *)key {
    NSParameterAssert(canvasView == self.view);
    id nativeView = [self valueForKey:key];
    if (nativeView && [nativeView isKindOfClass:UIView.class]) {
        return nativeView;
    }
    return nil;
}

- (void)canvasView:(FCCanvasView *)canvasView onEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender {
    NSParameterAssert(canvasView == self.view);
    NSParameterAssert(message && message.length);
    if (!message || !message.length) {
        return;
    }
    
    // openURL
    if ([message hasPrefix:@"https:"] || [message hasPrefix:@"http:"]) {
        NSURL *url = [NSURL URLWithString:message];
        if (url && [self openURL:url withEvent:event userInfo:userInfo sender:sender]) {
            return;
        }
    }
    
    // onRef
    if ([event isEqualToString:@"onRef"] && [sender isKindOfClass:UIView.class]) {
        NSString *msg = [message stringByAppendingString:@":"];
        msg = [NSString stringWithFormat:@"set%@%@", [msg substringToIndex:1].uppercaseString, [msg substringFromIndex:1]];
        SEL sel = NSSelectorFromString(msg);
        if ([self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:sel withObject:sender];
#pragma clang diagnostic pop
            return;
        }
    }
    
    // <message>:sender:
    if (sender) {
        NSString *msg = [message stringByAppendingString:@":sender:"];
        SEL sel = NSSelectorFromString(msg);
        if (sel && [self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self performSelector:sel withObject:userInfo withObject:sender];
#pragma clang diagnostic pop
            return;
        }
    }
    
    // <message>:
    NSString *msg = [message stringByAppendingString:@":"];
    SEL sel = NSSelectorFromString(msg);
    if (sel && [self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel withObject:userInfo];
#pragma clang diagnostic pop
        return;
    }
    
    msg = message;
    sel = NSSelectorFromString(msg);
    if (sel && [self respondsToSelector:sel]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self performSelector:sel];
#pragma clang diagnostic pop
        return;
    }
}

@end
