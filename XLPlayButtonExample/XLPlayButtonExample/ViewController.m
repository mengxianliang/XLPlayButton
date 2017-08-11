//
//  ViewController.m
//  XLPlayButtonExample
//
//  Created by MengXianLiang on 2017/8/9.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "ViewController.h"
#import "iQiYiPlayButton.h"
#import "YouKuPlayButton.h"
@interface ViewController (){
    
    iQiYiPlayButton *_iQiYiPlayButton;
    
    YouKuPlayButton *_youKuPlayButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建播放按钮，需要初始化一个状态，即显示暂停还是播放状态
    _iQiYiPlayButton = [[iQiYiPlayButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) state:iQiYiPlayButtonStatePlay];
    _iQiYiPlayButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height/3);
    [_iQiYiPlayButton addTarget:self action:@selector(iQiYiPlayMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_iQiYiPlayButton];
    
    //创建播放按钮，需要初始化一个状态，即显示暂停还是播放状态
    _youKuPlayButton = [[YouKuPlayButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60) state:YouKuPlayButtonStatePlay];
    _youKuPlayButton.center = CGPointMake(self.view.center.x, self.view.bounds.size.height*2/3);
    [_youKuPlayButton addTarget:self action:@selector(youKuPlayMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_youKuPlayButton];
}

- (void)iQiYiPlayMethod {
    //通过判断当前状态 切换显示状态
    if (_iQiYiPlayButton.buttonState == iQiYiPlayButtonStatePause) {
        _iQiYiPlayButton.buttonState = iQiYiPlayButtonStatePlay;
    }else {
        _iQiYiPlayButton.buttonState = iQiYiPlayButtonStatePause;
    }
}

- (void)youKuPlayMethod {
    //通过判断当前状态 切换显示状态
    if (_youKuPlayButton.buttonState == YouKuPlayButtonStatePause) {
        _youKuPlayButton.buttonState = YouKuPlayButtonStatePlay;
    }else {
        _youKuPlayButton.buttonState = YouKuPlayButtonStatePause;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
