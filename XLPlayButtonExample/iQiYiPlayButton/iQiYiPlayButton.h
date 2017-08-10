//
//  iQiYiPlayButton.h
//  XLPlayButtonExample
//
//  Created by MengXianLiang on 2017/8/9.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,iQiYiPlayButtonState) {
    iQiYiPlayButtonStatePause = 0,
    iQiYiPlayButtonStatePlay
};

@interface iQiYiPlayButton : UIButton

/**
 通过setter方式控制按钮动画
 设置XLPlayButtonStatePlay显示播放按钮
 设置XLPlayButtonStatePause显示暂停按钮
 */
@property (nonatomic, assign) iQiYiPlayButtonState buttonState;

/**
 创建方法
 */
- (instancetype)initWithFrame:(CGRect)frame state:(iQiYiPlayButtonState)state;

@end
