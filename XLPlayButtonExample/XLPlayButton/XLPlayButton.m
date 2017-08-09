//
//  XLPlayButton.m
//  爱奇艺播放按钮动画
//
//  Created by MengXianLiang on 2017/8/9.
//  Copyright © 2017年 JWZT. All rights reserved.
//

#import "XLPlayButton.h"

static CGFloat lineWidth = 15.0f;
static CGFloat checkDuration = 0.5f;
static CGFloat positionDuration = 0.3;
#define BlueColor [UIColor colorWithRed:16/255.0 green:142/255.0 blue:233/255.0 alpha:1]


@interface XLPlayButton ()<CAAnimationDelegate> {
    
    //是否正在执行动画
    BOOL _isAnimating;
    
    //左侧竖条
    CAShapeLayer *_leftLineLayer;
    //三角
    CAShapeLayer *_triangleLayer;
    //右侧竖条
    CAShapeLayer *_rightLineLayer;
    //画弧layer
    CAShapeLayer *_circleLayer;
}
@end

@implementation XLPlayButton

- (instancetype)initWithFrame:(CGRect)frame state:(XLPlayButtonState)state{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        if (state == XLPlayButtonStatePlay) {
            self.buttonState = state;
        }
    }
    return self;
}

/**
 创建UI
 */
- (void)buildUI {
    _buttonState = XLPlayButtonStatePause;
    [self addTriangleLayer];
    [self addLeftLineLayer];
    [self addRightLineLayer];
    [self addCircleLayer];
}

/**
 添加左侧竖线层
 */
- (void)addLeftLineLayer {
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.3,a*0.2)];
    [path addLineToPoint:CGPointMake(a*0.3,a*0.8)];
    
    _leftLineLayer = [CAShapeLayer layer];
    _leftLineLayer.path = path.CGPath;
    _leftLineLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLineLayer.strokeColor = BlueColor.CGColor;
    _leftLineLayer.lineWidth = lineWidth;
    _leftLineLayer.lineCap = kCALineCapRound;
    _leftLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_leftLineLayer];
}

/**
 添加三角层
 */
- (void)addTriangleLayer {
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.3,a*0.2)];
    [path addLineToPoint:CGPointMake(a*0.3,0)];
    [path addLineToPoint:CGPointMake(a,a*0.5)];
    [path addLineToPoint:CGPointMake(a*0.3,a)];
    [path addLineToPoint:CGPointMake(a*0.3,a*0.2)];
    
    _triangleLayer = [CAShapeLayer layer];
    _triangleLayer.path = path.CGPath;
    _triangleLayer.fillColor = [UIColor clearColor].CGColor;
    _triangleLayer.strokeColor = BlueColor.CGColor;
    _triangleLayer.lineWidth = lineWidth;
    _triangleLayer.lineCap = kCALineCapButt;
    _triangleLayer.lineJoin = kCALineJoinRound;
    _triangleLayer.strokeEnd = 0;
    [self.layer addSublayer:_triangleLayer];
}

/**
 添加右侧竖线层
 */
- (void)addRightLineLayer {
    
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.7,a*0.8)];
    [path addLineToPoint:CGPointMake(a*0.7,a*0.2)];
    
    _rightLineLayer = [CAShapeLayer layer];
    _rightLineLayer.path = path.CGPath;
    _rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLineLayer.strokeColor = BlueColor.CGColor;
    _rightLineLayer.lineWidth = lineWidth;
    _rightLineLayer.lineCap = kCALineCapRound;
    _rightLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_rightLineLayer];
}
/**
 添加画弧层
 */
- (void)addCircleLayer {
    
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.7,a*0.8)];
    [path addArcWithCenter:CGPointMake(a*0.5, a*0.8) radius:0.2*a startAngle:0 endAngle:M_PI clockwise:true];
    
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.path = path.CGPath;
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.strokeColor = BlueColor.CGColor;
    _circleLayer.lineWidth = lineWidth;
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.lineJoin = kCALineJoinRound;
    _circleLayer.strokeEnd = 0;
    [self.layer addSublayer:_circleLayer];
}

/**
 位移变化动画
 */
-(void)positionAnimationOfLayer:(CALayer*)layer :(CGFloat)yChange duration:(CGFloat)duration {
    CABasicAnimation *triangleAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    triangleAnimation.duration = duration/2;
    triangleAnimation.fromValue = @(layer.position.y);
    triangleAnimation.toValue = @(layer.position.y + yChange);
    triangleAnimation.autoreverses = YES;
    [triangleAnimation setValue:@"positionKey" forKey:@"animationName"];
    [layer addAnimation:triangleAnimation forKey:nil];
}

/**
 执行正向动画，即暂停-》播放
 */

- (void)actionPositiveAnimation {
    [self triangleAnimationFrome:0 to:1];
    [self rightLineAnimationFrome:1 to:0];
    [self circleEndAnimationFrome:0 to:1];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  checkDuration*0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self circleStartAnimationFrome:0 to:1];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  checkDuration*0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self leftLineAnimationFrome:1 to:0];
    });
}

/**
 执行逆向动画，即播放-》暂停
 */
- (void)actionInverseAnimation {
    [self triangleAnimationFrome:1 to:0];
    [self leftLineAnimationFrome:0 to:1];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  checkDuration*0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self circleStartAnimationFrome:1 to:0];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  checkDuration*0.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self rightLineAnimationFrome:0 to:1];
        [self circleEndAnimationFrome:1 to:0];
    });
}

/**
 三角形动画
 */
- (void)triangleAnimationFrome:(CGFloat)fromeValue to:(CGFloat)toValue {
    
    CABasicAnimation *triangleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    triangleAnimation.duration = checkDuration;
    triangleAnimation.fromValue = @(fromeValue);
    triangleAnimation.toValue = @(toValue);
    triangleAnimation.fillMode = kCAFillModeForwards;
    triangleAnimation.removedOnCompletion = NO;
    triangleAnimation.delegate = self;
    [triangleAnimation setValue:@"triangleAnimation" forKey:@"animationName"];
    [_triangleLayer addAnimation:triangleAnimation forKey:nil];
}

/**
 左侧竖条动画
 */
- (void)leftLineAnimationFrome:(CGFloat)fromeValue to:(CGFloat)toValue {
    
    CABasicAnimation *leftLineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leftLineAnimation.duration = checkDuration/2;
    leftLineAnimation.fromValue = @(fromeValue);
    leftLineAnimation.toValue = @(toValue);
    leftLineAnimation.fillMode = kCAFillModeForwards;
    leftLineAnimation.removedOnCompletion = NO;
    [leftLineAnimation setValue:@"leftLineAnimation" forKey:@"animationName"];
    [_leftLineLayer addAnimation:leftLineAnimation forKey:nil];
}

/**
 右侧竖线动画
 */
- (void)rightLineAnimationFrome:(CGFloat)fromeValue to:(CGFloat)toValue {
    
    CABasicAnimation *rightLineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    rightLineAnimation.duration = checkDuration/4;
    rightLineAnimation.fromValue = @(fromeValue);
    rightLineAnimation.toValue = @(toValue);
    rightLineAnimation.fillMode = kCAFillModeForwards;
    rightLineAnimation.removedOnCompletion = NO;
    [rightLineAnimation setValue:@"rightLineAnimation" forKey:@"animationName"];
    rightLineAnimation.delegate = self;
    [_rightLineLayer addAnimation:rightLineAnimation forKey:nil];
}



/**
 画弧改变终止位置动画
 */
- (void)circleEndAnimationFrome:(CGFloat)fromeValue to:(CGFloat)toValue {
    
    CABasicAnimation *leftLineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    leftLineAnimation.duration = checkDuration/4;
    leftLineAnimation.fromValue = @(fromeValue);
    leftLineAnimation.toValue = @(toValue);
    leftLineAnimation.fillMode = kCAFillModeForwards;
    leftLineAnimation.removedOnCompletion = NO;
    [leftLineAnimation setValue:@"leftLineAnimation" forKey:@"animationName"];
    [_circleLayer addAnimation:leftLineAnimation forKey:nil];
}

/**
 画弧改变起始位置动画
 */
- (void)circleStartAnimationFrome:(CGFloat)fromeValue to:(CGFloat)toValue {
    CABasicAnimation *leftLineAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    leftLineAnimation.duration = checkDuration/4;
    leftLineAnimation.fromValue = @(fromeValue);
    leftLineAnimation.toValue = @(toValue);
    leftLineAnimation.fillMode = kCAFillModeForwards;
    leftLineAnimation.removedOnCompletion = NO;
    [leftLineAnimation setValue:@"leftLineAnimation" forKey:@"animationName"];
    [_circleLayer addAnimation:leftLineAnimation forKey:nil];
}


#pragma mark -
#pragma mark 动画开始、结束代理方法
-(void)animationDidStart:(CAAnimation *)anim {
    NSString *name = [anim valueForKey:@"animationName"];
    bool isTriangle = [name isEqualToString:@"triangleAnimation"];
    bool isRightLine = [name isEqualToString:@"rightLineAnimation"];
    if (isTriangle) {
        _triangleLayer.lineCap = kCALineCapRound;
    }else if (isRightLine){
        _rightLineLayer.lineCap = kCALineCapRound;
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *name = [anim valueForKey:@"animationName"];
    bool isTriangle = [name isEqualToString:@"triangleAnimation"];
    bool isRightLine = [name isEqualToString:@"rightLineAnimation"];
    if (_buttonState == XLPlayButtonStatePlay && isRightLine) {
        _rightLineLayer.lineCap = kCALineCapButt;
    }
    if (isTriangle) {
        _triangleLayer.lineCap = kCALineCapButt;
    }
}

#pragma mark -
#pragma mark 其他方法
/**
 执行strokeEnd动画
 */
- (CABasicAnimation *)strokeEndAnimationFrom:(CGFloat)fromeValue to:(CGFloat)toValue onLayer:(CALayer *)layer name:(NSString*)animationName {
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = checkDuration/4;
    strokeEndAnimation.fromValue = @(fromeValue);
    strokeEndAnimation.toValue = @(toValue);
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    [strokeEndAnimation setValue:animationName forKey:@"animationName"];
    strokeEndAnimation.delegate = self;
    [layer addAnimation:strokeEndAnimation forKey:nil];
    return strokeEndAnimation;
}


#pragma mark -
#pragma mark Setter
- (void)setButtonState:(XLPlayButtonState)buttonState {
    //如果正在执行动画则不再执行下面操作
    if (_isAnimating == true) {return;}
    _buttonState = buttonState;
    if (buttonState == XLPlayButtonStatePlay) {
        _isAnimating = true;
        //先执行左右竖线位移动画
        [self positionAnimationOfLayer:_leftLineLayer :20 duration:positionDuration];
        [self positionAnimationOfLayer:_rightLineLayer :-20 duration:positionDuration];
        //再执行画弧、画三角动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  positionDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            [self actionPositiveAnimation];
        });
    } else if (buttonState == XLPlayButtonStatePause) {
        _isAnimating = true;
        //先执行画弧、画三角动画
        [self actionInverseAnimation];
        //在执行竖线位移动画，结束动动画要比开始动画块
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  checkDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            [self positionAnimationOfLayer:_leftLineLayer :20 duration:positionDuration*0.7];
            [self positionAnimationOfLayer:_rightLineLayer :-20 duration:positionDuration*0.7];
        });
    }
    //更新动画执行状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  (positionDuration + checkDuration) * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        _isAnimating = false;
    });

}



@end
