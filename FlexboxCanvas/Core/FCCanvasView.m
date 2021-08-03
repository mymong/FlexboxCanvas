//
//  FCCanvasView.m
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/21.
//

#import "FCCanvasView.h"
#import "FCCanvas.h"
#import "FCElement.h"
#import "FCRenderer.h"
#import "FCVariableDispatcher.h"

@interface FCCanvasView () <FCCanvas>
@property (nonatomic, readonly) FCRenderer *renderer;
@property (nonatomic, readonly) NSMutableDictionary *variables;
@property (nonatomic, readonly) FCVariableDispatcher *dispatcher;
@end

@implementation FCCanvasView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _renderer = [[FCRenderer alloc] initWithView:self];
        _renderer.canvas = self;
        _variables = [NSMutableDictionary new];
        _dispatcher = [FCVariableDispatcher new];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.renderer render];
}

- (BOOL)loadElement:(FCElement *)element {
    if (element) {
        [self.renderer loadWithElement:element];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)loadXMLString:(NSString *)string {
    FCElement *element = [FCElement elementWithXMLString:string];
    return [self loadElement:element];
}

- (BOOL)loadXMLResource:(NSString *)name inBundle:(NSBundle *)bundle {
    FCElement *element = [FCElement elementWithXMLResource:name inBundle:bundle];
    return [self loadElement:element];
}

- (void)setValue:(nullable NSString *)value forManagedVariable:(NSString *)name {
    if (!name) {
        return;
    }
    NSString *oldvar = [_variables objectForKey:name];
    if (oldvar == value) {
        return;
    }
    if (oldvar && value && [oldvar isEqualToString:value]) {
        return;
    }
    if (value) {
        [_variables setObject:value forKey:name];
    } else {
        [_variables removeObjectForKey:name];
    }
    [_dispatcher dispatchChangeForName:name];
}

- (nullable NSString *)valueForManagedVariable:(NSString *)name {
    if (!name) {
        return nil;
    }
    return [_variables objectForKey:name];
}

- (void)dispatchVariableChangeForName:(NSString *)name {
    if (name && self.variableSource) {
        [_dispatcher dispatchChangeForName:name];
    }
}

#pragma mark <FCCanvas>

- (nullable UIView *)nativeViewForKey:(NSString *)key {
    if (self.delegate) {
        return [self.delegate canvasView:self nativeViewForKey:key];
    }
    return nil;
}

- (void)onEvent:(NSString *)event message:(NSString *)message userInfo:(nullable NSDictionary *)userInfo sender:(id)sender {
    if (self.delegate) {
        [self.delegate canvasView:self onEvent:event message:message userInfo:userInfo sender:sender];
    }
}

- (nullable NSString *)variableValueForName:(NSString *)name {
    NSString *value = [_variables objectForKey:name];
    if (!value && self.variableSource) {
        value = [self.variableSource canvasView:self variableValueForName:name];
    }
    return value;
}

- (void)addVariableListener:(id<FCVariableListener>)listener forNames:(NSArray<NSString *> *)names {
    for (NSString *name in names) {
        [_dispatcher addListener:listener forName:name];
    }
}

- (void)removeVariableListener:(id<FCVariableListener>)listener {
    [_dispatcher removeListener:listener];
}

@end
