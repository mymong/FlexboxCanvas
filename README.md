# FlexboxCanvas


## 功能
1. 使用Flexbox布局协议
2. 使用XML进行布局描述
3. 布局算法实现可按需定制（需实现FC_Node接口），当前已有Yoga 1.14的实现
```
pod 'FlexboxCanvas', :subspecs => ['Canvas', 'YogaLayout_1_14']
```

## 元素（Element）
元素解析XML所描述的节点。
1. <Box>容器元素，虚拟视图
参与布局计算，为子元素提供坐标系
2. <View>视图元素，通用视图
参与布局计算，可配置基础视图样式和事件

## 组件（Component）
组件实现元素所描述的能力。

## 键（key）
元素的key属性是可选常量，如果未提供会自动生成默认值，将据此实现组件的`重用`能力。
```
<View key="container">
```

## 分隔符
1.  `;`表达多个样式
2.  `:`表达键值对
3.  `,`表示一个值由多个部分构成，即数据结构的概念
4.  `|`表示多个值，即数组的概念
```
<View style="paddingHorizontal:16; backgroundColor:255,0,255; touchableOpacity">
    <LinearGradient style="positionType:absolute; position:0; startPoint:0,0; endPoint:0,1; locations:0|1; colors:white|#00FFFF,0.7"/>
</View>
```

## 样式（style）
元素的style属性是组合格式的字符串，解析后的样式字典可为组件所用。

## 变量
1. 变量可用于元素的除`key`之外的所有属性值
2. 使用`{字符串}`来描述变量名，通常用路径表示法，如：{user/name}
3. 组件渲染过程中，在将元素样式字符串转换为组件样式字典的时候会从`Canvas`获取所有变量的值

## 事件
1. 事件通过元素的属性表达
2. 使用`on`前缀描述事件，如：onPress
3. 使用字符串描述消息，通常用路径表示法，可带变量参数，如：onPress=“alert?message=欢迎{user/name}”同学
4. 当事件触发时，将会向`Canvas`发送事件及消息

## <Box>
## Box Style
1.  `direction` 书写方向，枚举值：inherit, ltr, rtl
2.  `flexDirection` 主轴方向，枚举值：column, columnReverse, row, rowReverse
3.  `justifyContent` 主轴内容默认对齐方式，枚举值：flexStart, center, flexEnd, spaceBetween, spaceAround, spaceEvenly
4.  `alignItems` 副轴内容默认对齐方式，align枚举值：auto, flexStart, center, flexEnd, stretch, baseline, spaceBetween, spaceAround
5.  `alignContent` ，副轴内容多行时，这些行的对齐方式，参考align枚举值
6.  `alignSelf` 重载自身在其父元素中沿副轴的对齐方式，参考align枚举值
7.  `positionType` 位置类型，枚举值：relative, absolute
8.  `flexWrap` 伸缩换行，枚举值：noWrap, wrap, wrapReverse
9.  `overflow` 溢出部分如何显示，枚举值：visible, hidden
10.  `flex`
11.  `flexGrow`
12.  `flexShrink`
13.  `flexBasis`
14.  `margin`
15.  `marginHorizontal` `marginVertical` `marginStart` `marginEnd`
16.  `marginLeft` `marginTop` `marginRight` `marginBottom`
17.  `position`
18.  `positionHorizontal` `positionVertical`
19.  `positionLeft` `positionTop` `positionRight` `positionBottom`
20.  `padding`
21.  `paddingHorizontal` `paddingVertical` `paddingStart` `paddingEnd`
22.  `paddingLeft` `paddingTop` `paddingRight` `paddingBottom`
23.  `border`
24.  `borderHorizontal` `borderVertical` `borderStart` `borderEnd`
25.  `borderLeft` `borderTop` `borderRight` `borderBottom`
26.  `size` `width` `height`
27.  `minSize` `minWidth` `minHeight`
28.  `maxSize` `maxWidth` `maxHeight`
29.  `aspectRatio` 宽高比，比例或浮点数，如 3:2 或 1.5

## <View> 基础视图
### View Style
1. 继承自Box Style
2.  `opacity` 透明度，0 ~ 1的浮点数
3.  `overflow` 参考Box Style中的overflow，如果'hidden'则超出当前视图区域之外的内容将不被显示
4.  `backgroundColor` 背景色，颜色
5.  `borderColor` 边框色，颜色
7.  `borderRadius` 边框圆角，浮点数
8.  `borderCorner` 边框圆角，数组，数据来源：all, topLeft, topRight, bottomLeft, bottomRight, top, bottom, left, right，默认all
8.  `shadowColor` 阴影颜色
9.  `shadowOffset` 阴影偏移
10.  `shadowOpacity` 阴影透明度
11. `shadowRadius` 阴影半径，羽化范围

### View Props
1.  `nativeView`  自定义视图对象的标识名
2.  `touchableOpacity` 触摸时是否有透明效果

### View Events
1.  `onRef` 引用事件，当视图对象加入画布时触发，客户端持有引用视图时请注意使用`weak`声明
2.  `onPress` 点击事件
3.  `onLongPress` 长按事件


## Installation

FlexboxCanvas is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FlexboxCanvas'
```

## Example

```
FCCanvasView *canvas = [[FCCanvasView alloc] initWithFrame:self.view.bounds];
[self.view addSubview:canvas];
[canvas loadXMLResource:@"test.xml" inBundle:nil];
```

## Author

mymong, mymong@163.com

## License

FlexboxCanvas is available under the MIT license. See the LICENSE file for more info.
