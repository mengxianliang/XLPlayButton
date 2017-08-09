//
//  ViewController.m
//  XLPlayButtonExample
//
//  Created by MengXianLiang on 2017/8/9.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "ViewController.h"
#import "XLPlayButton.h"
@interface ViewController (){
    XLPlayButton *_playButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建播放按钮，需要初始化一个状态，即显示暂停还是播放状态
    _playButton = [[XLPlayButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) state:XLPlayButtonStatePause];
    _playButton.center = self.view.center;
    [_playButton addTarget:self action:@selector(playMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)playMethod {
    //通过判断当前状态 切换显示状态
    if (_playButton.buttonState == XLPlayButtonStatePause) {
        _playButton.buttonState = XLPlayButtonStatePlay;
    }else {
        _playButton.buttonState = XLPlayButtonStatePause;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
