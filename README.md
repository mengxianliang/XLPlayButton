# XLPlayButton
爱奇艺播放、暂停按钮动画效果

### 显示效果

<img src="https://github.com/mengxianliang/XLPlayButton/blob/master/GIF/1.gif" width=300 height=538 />

### 使用方法

* XLPlayButton 是继承UIButton的，只是创建方式和UIButton不同，其他的使用方法均一致。
* 创建方法
```objc
    _playButton = [[XLPlayButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) state:XLPlayButtonStatePause];
```
* 唯一属性
```objc
/**
 通过setter方式控制按钮动画
 设置XLPlayButtonStatePlay显示播放按钮
 设置XLPlayButtonStatePause显示暂停按钮
 */
@property (nonatomic, assign) XLPlayButtonState buttonState;
```

### 个人开发过的UI工具集合 [XLUIKit](https://github.com/mengxianliang/XLUIKit)
