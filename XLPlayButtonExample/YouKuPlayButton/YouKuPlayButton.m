//
//  YouKuPlayButton.m
//  YouKuPlayButtonExample
//
//  Created by MengXianLiang on 2017/8/10.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "YouKuPlayButton.h"

//动画时长
static CGFloat animationDuration = 0.35f;
//线条颜色
#define BLueColor [UIColor colorWithRed:62/255.0 green:157/255.0 blue:254/255.0 alpha:1]
#define LightBLueColor [UIColor colorWithRed:87/255.0 green:188/255.0 blue:253/255.0 alpha:1]
#define RedColor [UIColor colorWithRed:228/255.0 green:35/255.0 blue:6/255.0 alpha:0.8]

@interface YouKuPlayButton () {
    CAShapeLayer *_leftLineLayer;
    CAShapeLayer *_leftCircle;
    CAShapeLayer *_rightLineLayer;
    CAShapeLayer *_rightCircle;
    //三角播放按钮容器
    CALayer *_triangleCotainer;
    //是否正在执行动画
    BOOL _isAnimating;
}
@end

@implementation YouKuPlayButton

- (instancetype)initWithFrame:(CGRect)frame state:(YouKuPlayButtonState)state{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        if (state == YouKuPlayButtonStatePlay) {
            self.buttonState = state;
        }
    }
    return self;
}

- (void)buildUI {
    [self addLeftCircle];
    [self addRightCircle];
    [self addLeftLineLayer];
    [self addRightLineLayer];
    [self addCenterTriangleLayer];
}

/**
 添加左侧竖线层
 */
- (void)addLeftLineLayer {
    CGFloat a = self.layer.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2,a*0.9)];
    [path addLineToPoint:CGPointMake(a*0.2,a*0.1)];
    
    _leftLineLayer = [CAShapeLayer layer];
    _leftLineLayer.path = path.CGPath;
    _leftLineLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLineLayer.strokeColor = BLueColor.CGColor;
    _leftLineLayer.lineWidth = [self lineWidth];
    _leftLineLayer.lineCap = kCALineCapRound;
    _leftLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_leftLineLayer];
}

/**
 添加左侧圆弧
 */

- (void)addLeftCircle {
    CGFloat a = self.layer.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2,a*0.9)];
    CGFloat startAngle = acos(4.0/5.0) + M_PI_2;
    CGFloat endAngle = startAngle - M_PI;
    [path addArcWithCenter:CGPointMake(a*0.5, a*0.5) radius:0.5*a startAngle:startAngle endAngle:endAngle clockwise:false];
    
    
    _leftCircle = [CAShapeLayer layer];
    _leftCircle.path = path.CGPath;
    _leftCircle.fillColor = [UIColor clearColor].CGColor;
    _leftCircle.strokeColor = LightBLueColor.CGColor;
    _leftCircle.lineWidth = [self lineWidth];
    _leftCircle.lineCap = kCALineCapRound;
    _leftCircle.lineJoin = kCALineJoinRound;
    _leftCircle.strokeEnd = 0;
    [self.layer addSublayer:_leftCircle];
}

/**
 添加右侧竖线层
 */
- (void)addRightLineLayer {
    
    CGFloat a = self.layer.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8,a*0.1)];
    [path addLineToPoint:CGPointMake(a*0.8,a*0.9)];
    
    _rightLineLayer = [CAShapeLayer layer];
    _rightLineLayer.path = path.CGPath;
    _rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLineLayer.strokeColor = BLueColor.CGColor;
    _rightLineLayer.lineWidth = [self lineWidth];
    _rightLineLayer.lineCap = kCALineCapRound;
    _rightLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_rightLineLayer];
}


/**
 添加左侧圆弧
 */

- (void)addRightCircle {
    
    CGFloat a = self.layer.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8,a*0.1)];
    CGFloat startAngle = -asin(4.0/5.0);
    CGFloat endAngle = startAngle - M_PI;
    [path addArcWithCenter:CGPointMake(a*0.5, a*0.5) radius:0.5*a startAngle:startAngle endAngle:endAngle clockwise:false];
    
    
    _rightCircle = [CAShapeLayer layer];
    _rightCircle.path = path.CGPath;
    _rightCircle.fillColor = [UIColor clearColor].CGColor;
    _rightCircle.strokeColor = LightBLueColor.CGColor;
    _rightCircle.lineWidth = [self lineWidth];
    _rightCircle.lineCap = kCALineCapRound;
    _rightCircle.lineJoin = kCALineJoinRound;
    _rightCircle.strokeEnd = 0;
    [self.layer addSublayer:_rightCircle];
}

/**
 添加左侧三角 由两个直线组成
 */
- (void)addCenterTriangleLayer {
    CGFloat a = self.layer.bounds.size.width;
    
    _triangleCotainer = [CALayer layer];
    _triangleCotainer.bounds = CGRectMake(0, 0, 0.4*a, 0.35*a);
    _triangleCotainer.position = CGPointMake(a*0.5, a*0.55);
    _triangleCotainer.opacity = 0;
    [self.layer addSublayer:_triangleCotainer];
    
    CGFloat b = _triangleCotainer.bounds.size.width;
    CGFloat c = _triangleCotainer.bounds.size.height;
    
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(0,0)];
    [path1 addLineToPoint:CGPointMake(b/2,c)];
    
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(b,0)];
    [path2 addLineToPoint:CGPointMake(b/2,c)];
    
    CAShapeLayer *layer1 = [CAShapeLayer layer];
    layer1.path = path1.CGPath;
    layer1.fillColor = [UIColor clearColor].CGColor;
    layer1.strokeColor = RedColor.CGColor;
    layer1.lineWidth = [self lineWidth];
    layer1.lineCap = kCALineCapRound;
    layer1.lineJoin = kCALineJoinRound;
    layer1.strokeEnd = 1;
    [_triangleCotainer addSublayer:layer1];
    
    CAShapeLayer *layer2 = [CAShapeLayer layer];
    layer2.path = path2.CGPath;
    layer2.fillColor = [UIColor clearColor].CGColor;
    layer2.strokeColor = RedColor.CGColor;
    layer2.lineWidth = [self lineWidth];
    layer2.lineCap = kCALineCapRound;
    layer2.lineJoin = kCALineJoinRound;
    layer2.strokeEnd = 1;
    [_triangleCotainer addSublayer:layer2];
}

#pragma mark -
#pragma mark 动画方法
/**
 通用执行strokeEnd动画
 */
- (CABasicAnimation *)strokeEndAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue onLayer:(CALayer *)layer name:(NSString*)animationName duration:(CGFloat)duration delegate:(id)delegate {
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = duration;
    strokeEndAnimation.fromValue = @(fromValue);
    strokeEndAnimation.toValue = @(toValue);
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    [strokeEndAnimation setValue:animationName forKey:@"animationName"];
    strokeEndAnimation.delegate = delegate;
    [layer addAnimation:strokeEndAnimation forKey:nil];
    return strokeEndAnimation;
}

/**
 执行旋转动画
 */
- (void)actionRotateAnimationClockwise:(BOOL)clockwise {
    //逆时针旋转
    CGFloat startAngle = 0.0;
    CGFloat endAngle = -M_PI_2;
    CGFloat duration = 0.75 * animationDuration;
    //顺时针旋转
    if (clockwise) {
        startAngle = -M_PI_2;
        endAngle = 0.0;
        duration = animationDuration;
    }
    CABasicAnimation *roateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    roateAnimation.duration = duration; // 持续时间
    roateAnimation.fromValue = [NSNumber numberWithFloat:startAngle];
    roateAnimation.toValue = [NSNumber numberWithFloat:endAngle];
    roateAnimation.fillMode = kCAFillModeForwards;
    roateAnimation.removedOnCompletion = NO;
    [roateAnimation setValue:@"roateAnimation" forKey:@"animationName"];
    [self.layer addAnimation:roateAnimation forKey:nil];
}

/**
 三角旋转动画
 */
- (void)actionTriangleAlphaAnimationFrom:(CGFloat)from to:(CGFloat)to duration:(CGFloat)duration{
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    alphaAnimation.duration = duration; // 持续时间
    alphaAnimation.fromValue = @(from);
    alphaAnimation.toValue = @(to);
    alphaAnimation.fillMode = kCAFillModeForwards;
    alphaAnimation.removedOnCompletion = NO;
    [alphaAnimation setValue:@"alphaAnimation" forKey:@"animationName"];
    [_triangleCotainer addAnimation:alphaAnimation forKey:nil];
}

//线条宽度，根据按钮的宽度按比例设置
- (CGFloat)lineWidth {
    return self.layer.bounds.size.width * 0.18;
}

#pragma mark -
#pragma mark Setter
- (void)setButtonState:(YouKuPlayButtonState)buttonState {
    //如果正在执行动画则不再执行下面操作
    if (_isAnimating == true) {return;}
    _buttonState = buttonState;
    _isAnimating = true;
    if (buttonState == YouKuPlayButtonStatePlay) {
        [self showPlayAnimation];
    } else if (buttonState == YouKuPlayButtonStatePause) {
        [self showPauseAnimation];
    }
    //更新动画执行状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  (animationDuration) * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        _isAnimating = false;
    });
}
/**
 显示暂停-播放动画
 */
- (void)showPlayAnimation {
    //收直线、放圆圈；直线的速度是圆圈的2倍
    [self strokeEndAnimationFrom:1 to:0 onLayer:_leftLineLayer name:nil duration:animationDuration/2 delegate:nil];
    [self strokeEndAnimationFrom:1 to:0 onLayer:_rightLineLayer name:nil duration:animationDuration/2 delegate:nil];
    [self strokeEndAnimationFrom:0 to:1 onLayer:_leftCircle name:nil duration:animationDuration delegate:nil];
    [self strokeEndAnimationFrom:0 to:1 onLayer:_rightCircle name:nil duration:animationDuration delegate:nil];
    //开始旋转动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration/4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self actionRotateAnimationClockwise:false];
    });
    //显示播放三角动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self actionTriangleAlphaAnimationFrom:0 to:1 duration:animationDuration/2];
    });
}

/**
 显示播放-暂停动画
 */
- (void)showPauseAnimation {
    //先收圆圈，
    [self strokeEndAnimationFrom:1 to:0 onLayer:_leftCircle name:nil duration:animationDuration delegate:nil];
    [self strokeEndAnimationFrom:1 to:0 onLayer:_rightCircle name:nil duration:animationDuration delegate:nil];
    //隐藏播放三角动画
    [self actionTriangleAlphaAnimationFrom:1 to:0 duration:animationDuration/2];
    //旋转动画
    [self actionRotateAnimationClockwise:true];
    //收到一半再放直线
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self strokeEndAnimationFrom:0 to:1 onLayer:_leftLineLayer name:nil duration:animationDuration/2 delegate:nil];
        [self strokeEndAnimationFrom:0 to:1 onLayer:_rightLineLayer name:nil duration:animationDuration/2 delegate:nil];
    });
}

@end
