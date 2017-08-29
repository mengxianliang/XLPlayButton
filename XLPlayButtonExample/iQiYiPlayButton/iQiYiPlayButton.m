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

#pragma mark -
#pragma mark 添加动画层
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
 添加左侧竖线层
 */
- (void)addLeftLineLayer {
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.2,0)];
    [path addLineToPoint:CGPointMake(a*0.2,a)];
    
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
 添加右侧竖线层
 */
- (void)addRightLineLayer {
    
    CGFloat a = self.bounds.size.width;
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(a*0.8,a)];
    [path addLineToPoint:CGPointMake(a*0.8,0)];
    
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
 添加弧线过渡弧线层
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
    [self strokeEndAnimationFrom:0 to:1 onLayer:_triangleLayer name:TriangleAnimation duration:animationDuration delegate:self];
    //开始右侧线条动画
    [self strokeEndAnimationFrom:1 to:0 onLayer:_rightLineLayer name:RightLineAnimation duration:animationDuration/4 delegate:self];
    //开始画弧动画
    [self strokeEndAnimationFrom:0 to:1 onLayer:_circleLayer name:nil duration:animationDuration/4 delegate:nil];
    //开始逆向画弧动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration*0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self circleStartAnimationFrom:0 to:1];
    });
    //开始左侧线条缩短动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration*0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //左侧竖线动画
        [self strokeEndAnimationFrom:1 to:0 onLayer:_leftLineLayer name:nil duration:animationDuration/2 delegate:nil];
    });
}

/**
 执行逆向动画，即播放-》暂停
 */
- (void)actionInverseAnimation {
    //开始三角动画
    [self strokeEndAnimationFrom:1 to:0 onLayer:_triangleLayer name:TriangleAnimation duration:animationDuration delegate:self];
    //开始左侧线条动画
    [self strokeEndAnimationFrom:0 to:1 onLayer:_leftLineLayer name:nil duration:animationDuration/2 delegate:nil];
    //执行画弧动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration*0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        [self circleStartAnimationFrom:1 to:0];
    });
    //执行反向画弧和右侧放大动画
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration*0.75 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //右侧竖线动画
        [self strokeEndAnimationFrom:0 to:1 onLayer:_rightLineLayer name:RightLineAnimation duration:animationDuration/4 delegate:self];
        //圆弧动画
        [self strokeEndAnimationFrom:1 to:0 onLayer:_circleLayer name:nil duration:animationDuration/4 delegate:nil];
    });
}

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
 画弧改变起始位置动画
 */
- (void)circleStartAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue {
    CABasicAnimation *circleAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    circleAnimation.duration = animationDuration/4;
    circleAnimation.fromValue = @(fromValue);
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
//线条宽度，根据按钮的宽度按比例设置
- (CGFloat)lineWidth {
    return self.bounds.size.width * 0.2;
}


#pragma mark -
#pragma mark 竖线动画
//暂停-》播放竖线动画
- (void)linePositiveAnimation {
    CGFloat a = self.bounds.size.width;
    
    //左侧缩放动画
    UIBezierPath *leftPath1 = [UIBezierPath bezierPath];
    [leftPath1 moveToPoint:CGPointMake(0.2*a,0.4*a)];
    [leftPath1 addLineToPoint:CGPointMake(0.2*a,a)];
    _leftLineLayer.path = leftPath1.CGPath;
    [_leftLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    
    //右侧竖线位移动画
    UIBezierPath *rightPath1 = [UIBezierPath bezierPath];
    [rightPath1 moveToPoint:CGPointMake(0.8*a, 0.8*a)];
    [rightPath1 addLineToPoint:CGPointMake(0.8*a,-0.2*a)];
    _rightLineLayer.path = rightPath1.CGPath;
    [_rightLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  positionDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //左侧位移动画
        UIBezierPath *leftPath2 = [UIBezierPath bezierPath];
        [leftPath2 moveToPoint:CGPointMake(a*0.2,a*0.2)];
        [leftPath2 addLineToPoint:CGPointMake(a*0.2,a*0.8)];
        _leftLineLayer.path = leftPath2.CGPath;
        [_leftLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
        
        //右侧竖线缩放动画
        UIBezierPath *rightPath2 = [UIBezierPath bezierPath];
        [rightPath2 moveToPoint:CGPointMake(a*0.8,a*0.8)];
        [rightPath2 addLineToPoint:CGPointMake(a*0.8,a*0.2)];
        _rightLineLayer.path = rightPath2.CGPath;
        [_rightLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    });
}

//播放-》暂停竖线动画
- (void)lineInverseAnimation {
    
    CGFloat a = self.bounds.size.width;
    //左侧位移动画
    UIBezierPath *leftPath1 = [UIBezierPath bezierPath];
    [leftPath1 moveToPoint:CGPointMake(0.2*a,0.4*a)];
    [leftPath1 addLineToPoint:CGPointMake(0.2*a,a)];
    _leftLineLayer.path = leftPath1.CGPath;
    [_leftLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    
    //右侧竖线位移动画
    UIBezierPath *rightPath1 = [UIBezierPath bezierPath];
    [rightPath1 moveToPoint:CGPointMake(0.8*a, 0.8*a)];
    [rightPath1 addLineToPoint:CGPointMake(0.8*a,-0.2*a)];
    _rightLineLayer.path = rightPath1.CGPath;
    [_rightLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  positionDuration/2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        //左侧竖线缩放动画
        UIBezierPath *leftPath2 = [UIBezierPath bezierPath];
        [leftPath2 moveToPoint:CGPointMake(a*0.2,0)];
        [leftPath2 addLineToPoint:CGPointMake(a*0.2,a)];
        _leftLineLayer.path = leftPath2.CGPath;
        [_leftLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
        
        //右侧竖线缩放动画
        UIBezierPath *rightPath2 = [UIBezierPath bezierPath];
        [rightPath2 moveToPoint:CGPointMake(a*0.8,a)];
        [rightPath2 addLineToPoint:CGPointMake(a*0.8,0)];
        _rightLineLayer.path = rightPath2.CGPath;
        [_rightLineLayer addAnimation:[self pathAnimationWithDuration:positionDuration/2] forKey:nil];
    });
}

/**
 通用path动画方法
 */
- (CABasicAnimation *)pathAnimationWithDuration:(CGFloat)duration {
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.duration = duration;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    return pathAnimation;
}



#pragma mark -
#pragma mark Setter
- (void)setButtonState:(iQiYiPlayButtonState)buttonState {
    //如果正在执行动画则不再执行下面操作
    if (_isAnimating == true) {return;}
    _buttonState = buttonState;
    
    if (buttonState == iQiYiPlayButtonStatePlay) {//暂停-》播放
        _isAnimating = true;
        //竖线正向动画
        [self linePositiveAnimation];
        //再执行画弧、画三角动画
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  positionDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            [self actionPositiveAnimation];
        });
    } else if (buttonState == iQiYiPlayButtonStatePause) {//播放-》暂停
        _isAnimating = true;
        //先执行画弧、画三角动画
        [self actionInverseAnimation];
        //在执行竖线位移动画，结束动动画要比开始动画块
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  animationDuration * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            //竖线逆向动画
            [self lineInverseAnimation];
        });
    }
    //更新动画执行状态
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,  (positionDuration + animationDuration) * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        _isAnimating = false;
    });
}


@end
