//
//  FCComponentHierachy.h
//  FlexboxCanvas
//
//  Created by Guang Yang on 2021/7/23.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FCComponentHierachy <NSObject>
///【开始渲染】【主线程】按需重构组件树，包括组件的重用、新建、删除，包括属性集的变量解析和取值。
- (void)startComponentHierachy;
///【开始布局】【次线程】重新连接布局树，样式的解析和应用。
- (void)startLayoutHierachy;
///【结束布局】【次线程】遍历布局树，进行后处理，对布局的结果坐标进行调整。
- (void)finishLayoutHierachy;
///【结束渲染】【主线程】遍历组件树，进行后处理，对托管的视图对象进行配置。
- (void)finishComponentHierachy;
@end

NS_ASSUME_NONNULL_END
