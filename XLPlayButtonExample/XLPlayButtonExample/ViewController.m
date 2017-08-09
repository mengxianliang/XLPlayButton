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
    
    _playButton = [[XLPlayButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100) state:XLPlayButtonStatePause];
    [_playButton addTarget:self action:@selector(playMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playButton];
}

- (void)playMethod {
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
