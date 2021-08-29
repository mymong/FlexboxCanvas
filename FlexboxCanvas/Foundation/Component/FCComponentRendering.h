//
//  FCComponentRendering.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FCComponentRendering <NSObject>

///【开始渲染】【主线程】
/// 1）将所需数据移入渲染环境（这样在非主线程进行布局的时候，可以在主线程接收新的数据，互不影响）；
/// 2）当有新的元素时，重建所有子组件（包含重用逻辑，根据key和name重用已经存在的子组件）；
/// 3）遍历所有子组件，下发执行该方法。
- (void)startComponentRender;

///【开始布局】【次线程】
/// 1）当有新的元素时，重配节点的样式；
/// 2）遍历所有子组件，下发执行该方法。
/// 3）当有新的元素时，重链所有子节点（需检查子节点是否有变化）；
- (void)startComponentLayout;

///【结束布局】【次线程】
/// 1）注：此时所有子节点已经完成布局的配置和计算；
/// 2）确定组件的frame（注意是组件相对于其superview的frame，从节点的frame转换而来）；
/// 3）遍历所有子组件，下发执行该方法。 
- (void)finishComponentLayout;

///【结束渲染】【主线程】
/// 1）当有新的元素时，重建托管视图，否则仅更新视图frame；
/// 2）遍历所有子组件，下发执行该方法；
/// 3）进行必要的后处理；
/// 4）擦除多余渲染痕迹。
- (void)finishComponentRender;

@end

NS_ASSUME_NONNULL_END
