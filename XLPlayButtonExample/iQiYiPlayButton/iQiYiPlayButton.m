//
//  iQiYiPlayButton.m
//  XLPlayButtonExample
//
//  Created by MengXianLiang on 2017/8/9.
//  Copyright © 2017年 mxl. All rights reserved.
//

#import "iQiYiPlayButton.h"

//其它动画时长
static CGFloat animationDuration = 0.5f;
//位移动画时长
static CGFloat positionDuration = 0.3f;
//线条颜色
#define LineColor [UIColor colorWithRed:12/255.0 green:190/255.0 blue:6/255.0 alpha:1]
//三角动画名称
#define TriangleAnimation @"TriangleAnimation"
//右侧直线动画名称
#define RightLineAnimation @"RightLineAnimation"

@interface iQiYiPlayButton ()<CAAnimationDelegate> {
    
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

@implementation iQiYiPlayButton

- (instancetype)initWithFrame:(CGRect)frame state:(iQiYiPlayButtonState)state{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
        if (state == iQiYiPlayButtonStatePlay) {
            self.buttonState = state;
        }
    }
    return self;
}

/**
 创建UI
 */
- (void)buildUI {
    _buttonState = iQiYiPlayButtonStatePause;
    [self addTriangleLayer];
    [self addLeftLineLayer];
    [self addRightLineLayer];
    [self addCircleLayer];
}


-(void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    if (_buttonState == iQiYiPlayButtonStatePause) {
        [self heigherLineLayer:true];
    }
}

#pragma mark -
#pragma mark 添加动画层

/**
 添加左侧竖线层
 */
- (void)addLeftLineLayer {
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2,a*0.2)];
    [path addLineToPoint:CGPointMake(a*0.2,a*0.8)];
    
    _leftLineLayer = [CAShapeLayer layer];
    _leftLineLayer.path = path.CGPath;
    _leftLineLayer.fillColor = [UIColor clearColor].CGColor;
    _leftLineLayer.strokeColor = LineColor.CGColor;
    _leftLineLayer.lineWidth = [self lineWidth];
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
    [path moveToPoint:CGPointMake(a*0.2,a*0.2)];
    [path addLineToPoint:CGPointMake(a*0.2,0)];
    [path addLineToPoint:CGPointMake(a,a*0.5)];
    [path addLineToPoint:CGPointMake(a*0.2,a)];
    [path addLineToPoint:CGPointMake(a*0.2,a*0.2)];
    
    _triangleLayer = [CAShapeLayer layer];
    _triangleLayer.path = path.CGPath;
    _triangleLayer.fillColor = [UIColor clearColor].CGColor;
    _triangleLayer.strokeColor = LineColor.CGColor;
    _triangleLayer.lineWidth = [self lineWidth];
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
    [path moveToPoint:CGPointMake(a*0.8,a*0.8)];
    [path addLineToPoint:CGPointMake(a*0.8,a*0.2)];
    
    _rightLineLayer = [CAShapeLayer layer];
    _rightLineLayer.path = path.CGPath;
    _rightLineLayer.fillColor = [UIColor clearColor].CGColor;
    _rightLineLayer.strokeColor = LineColor.CGColor;
    _rightLineLayer.lineWidth = [self lineWidth];
    _rightLineLayer.lineCap = kCALineCapRound;
    _rightLineLayer.lineJoin = kCALineJoinRound;
    [self.layer addSublayer:_rightLineLayer];
}
/**
 添加弧线过渡层
 */
- (void)addCircleLayer {
    
    CGFloat a = self.bounds.size.width;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8,a*0.8)];
    [path addArcWithCenter:CGPointMake(a*0.5, a*0.8) radius:0.3*a startAngle:0 endAngle:M_PI clockwise:true];
    
    _circleLayer = [CAShapeLayer layer];
    _circleLayer.path = path.CGPath;
    _circleLayer.fillColor = [UIColor clearColor].CGColor;
    _circleLayer.strokeColor = LineColor.CGColor;
    _circleLayer.lineWidth = [self lineWidth];
    _circleLayer.lineCap = kCALineCapRound;
    _circleLayer.lineJoin = kCALineJoinRound;
    _circleLayer.strokeEnd = 0;
    [self.layer addSublayer:_circleLayer];
}

#pragma mark -
#pragma mark 动画执行方法
/**
 执行正向动画，即暂停-》播放
 */
- (void)actionPositiveAnimation {
    //开始三角动画
    [self triangleAnimationFrom:0 to:1];
    //开始右侧线条动画
    [self rightLineAnimationFrom:1 to:0];
    //开始画弧动画
    [self circleEndAnimationFrom:0 to:1];
    //开始逆向画弧动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration*0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self circleStartAnimationFrome:0 to:1];
    });
    //开始左侧线条缩短动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration*0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self leftLineAnimationFrom:1 to:0];
    });
}

/**
 执行逆向动画，即播放-》暂停
 */
- (void)actionInverseAnimation {
    //开始三角动画
    [self triangleAnimationFrom:1 to:0];
    //开始左侧线条动画
    [self leftLineAnimationFrom:0 to:1];
    //执行画弧动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration*0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self circleStartAnimationFrome:1 to:0];
    });
    //执行反向画弧和右侧放大动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration*0.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self rightLineAnimationFrom:0 to:1];
        [self circleEndAnimationFrom:1 to:0];
    });
}

/**
 位移变化动画
 */
-(void)actionPositionAnimationDuration:(CGFloat)duration {
    CGFloat yChange = 0.2*self.bounds.size.width;
    CABasicAnimation *leftLinePositionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    leftLinePositionAnimation.duration = duration/2;
    leftLinePositionAnimation.fromValue = @(_leftLineLayer.position.y);
    leftLinePositionAnimation.toValue = @(_leftLineLayer.position.y + yChange);
    leftLinePositionAnimation.autoreverses = YES;
    [_leftLineLayer addAnimation:leftLinePositionAnimation forKey:nil];
    
    CABasicAnimation *rightLinePositionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    rightLinePositionAnimation.duration = duration/2;
    rightLinePositionAnimation.fromValue = @(_rightLineLayer.position.y);
    rightLinePositionAnimation.toValue = @(_rightLineLayer.position.y - yChange);
    rightLinePositionAnimation.autoreverses = YES;
    [_rightLineLayer addAnimation:rightLinePositionAnimation forKey:nil];
}


/**
 三角形动画
 */
- (void)triangleAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue {
    [self strokeEndAnimationFrom:fromValue to:toValue onLayer:_triangleLayer name:TriangleAnimation duration:animationDuration delegate:self];
}

/**
 左侧竖条动画
 */
- (void)leftLineAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue {
    
    [self strokeEndAnimationFrom:fromValue to:toValue onLayer:_leftLineLayer name:nil duration:animationDuration/2 delegate:nil];
}

/**
 右侧竖线动画
 */
- (void)rightLineAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue {
    [self strokeEndAnimationFrom:fromValue to:toValue onLayer:_rightLineLayer name:RightLineAnimation duration:animationDuration/4 delegate:self];
}

/**
 画弧改变终止位置动画
 */
- (void)circleEndAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue {
    
    [self strokeEndAnimationFrom:fromValue to:toValue onLayer:_circleLayer name:nil duration:animationDuration/4 delegate:nil];
}

/**
 画弧改变起始位置动画
 */
- (void)circleStartAnimationFrome:(CGFloat)fromeValue to:(CGFloat)toValue {
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    circleAnimation.duration = animationDuration/4;
    circleAnimation.fromValue = @(fromeValue);
    circleAnimation.toValue = @(toValue);
    circleAnimation.fillMode = kCAFillModeForwards;
    circleAnimation.removedOnCompletion = NO;
    [_circleLayer addAnimation:circleAnimation forKey:nil];
}


#pragma mark -
#pragma mark 动画开始、结束代理方法

//为了避免动画结束回到原点后会有一个原点显示在屏幕上需要做一些处理，就是改变layer的lineCap属性
-(void)animationDidStart:(CAAnimation *)anim {
    NSString *name = [anim valueForKey:@"animationName"];
    bool isTriangle = [name isEqualToString:TriangleAnimation];
    bool isRightLine = [name isEqualToString:RightLineAnimation];
    if (isTriangle) {
        _triangleLayer.lineCap = kCALineCapRound;
    }else if (isRightLine){
        _rightLineLayer.lineCap = kCALineCapRound;
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *name = [anim valueForKey:@"animationName"];
    bool isTriangle = [name isEqualToString:TriangleAnimation];
    bool isRightLine = [name isEqualToString:RightLineAnimation];
    if (_buttonState == iQiYiPlayButtonStatePlay && isRightLine) {
        _rightLineLayer.lineCap = kCALineCapButt;
    } else if (isTriangle) {
        _triangleLayer.lineCap = kCALineCapButt;
    }
}

#pragma mark -
#pragma mark 其他方法
/**
 通用执行strokeEnd动画
 */
- (CABasicAnimation *)strokeEndAnimationFrom:(CGFloat)fromeValue to:(CGFloat)toValue onLayer:(CALayer *)layer name:(NSString*)animationName duration:(CGFloat)duration delegate:(id)delegate {
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = duration;
    strokeEndAnimation.fromValue = @(fromeValue);
    strokeEndAnimation.toValue = @(toValue);
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.removedOnCompletion = NO;
    [strokeEndAnimation setValue:animationName forKey:@"animationName"];
    strokeEndAnimation.delegate = delegate;
    [layer addAnimation:strokeEndAnimation forKey:nil];
    return strokeEndAnimation;
}

//线条宽度，根据按钮的宽度按比例设置
- (CGFloat)lineWidth {
    return self.bounds.size.width * 0.2;
}

//加长暂停竖线
- (void)heigherLineLayer:(BOOL)heigher{
    CATransform3D t = CATransform3DIdentity;
    if (heigher) {
        t = CATransform3DScale(t, 1, 1.25, 0);
    } else {
        t = CATransform3DScale(t, 1, 1, 0);
    }
    _leftLineLayer.transform = t;
    _rightLineLayer.transform = t;
}


#pragma mark -
#pragma mark Setter
- (void)setButtonState:(iQiYiPlayButtonState)buttonState {
    //如果正在执行动画则不再执行下面操作
    if (_isAnimating == true) {return;}
    _buttonState = buttonState;
    if (buttonState == iQiYiPlayButtonStatePlay) {
        _isAnimating = true;
        //缩小暂停竖线
        [self heigherLineLayer:false];
        //先执行左右竖线位移动画
        [self actionPositionAnimationDuration:positionDuration];
        //再执行画弧、画三角动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  positionDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            [self actionPositiveAnimation];
        });
    } else if (buttonState == iQiYiPlayButtonStatePause) {
        _isAnimating = true;
        //先执行画弧、画三角动画
        [self actionInverseAnimation];
        //在执行竖线位移动画，结束动动画要比开始动画块
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            //放大暂停竖线
            [self heigherLineLayer:true];
            [self actionPositionAnimationDuration:0.7*positionDuration];
        });
    }
    //更新动画执行状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  (positionDuration + animationDuration) * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        _isAnimating = false;
    });
}



@end
