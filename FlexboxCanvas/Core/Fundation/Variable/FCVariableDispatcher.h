//
//  FCVariableDispatcher.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/28.
//

#import <Foundation/Foundation.h>

@protocol FCVariableListener;

NS_ASSUME_NONNULL_BEGIN

@protocol FCVariableDispatcherDelegate <NSObject>
- (void)willBeginVariableListeningForName:(NSString *)name;
- (void)didEndVariableListeningForName:(NSString *)name;
@end

@interface FCVariableDispatcher : NSObject
@property (nonatomic, nullable, weak) id<FCVariableDispatcherDelegate> delegate;
- (void)addListener:(id<FCVariableListener>)listener forName:(NSString *)name;
- (void)removeListener:(id<FCVariableListener>)listener;
- (void)removeAllListeners;
- (void)dispatchChangeForName:(NSString *)name;
@end

NS_ASSUME_NONNULL_END
