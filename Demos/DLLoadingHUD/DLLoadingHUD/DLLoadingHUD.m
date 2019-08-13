//
//  DLLoadingHUD.m
//  DLLoadingHUD
//
//  Created by David on 2019/8/13.
//  Copyright © 2019 David. All rights reserved.
//

#import "DLLoadingHUD.h"

#define PROGRESS_BAR_HEIGHT 20
#define PROGRESS_BAR_WIDTH 250

@interface DLLoadingHUD()<CAAnimationDelegate>

@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, assign) BOOL animating;

@end

@implementation DLLoadingHUD


-(instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)tapped:(UITapGestureRecognizer *)tapped {
    self.originFrame = self.frame;
    if (_animating) return;
    
    self.backgroundColor = [UIColor blueColor];
    
    for (CALayer *subLayer in self.layer.sublayers) {
        [subLayer removeFromSuperlayer];
    }
    
    self.layer.cornerRadius = PROGRESS_BAR_HEIGHT / 2;
    CABasicAnimation * radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    radiusAnimation.duration = 0.2f;
    radiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    radiusAnimation.fromValue = @(_originFrame.size.height / 2);
    radiusAnimation.delegate = self;
    
    [self.layer addAnimation:radiusAnimation forKey:@"cornerRadiusShrinkAnim"];
    
}

-(void)progressBarAnimation {
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGPoint point = CGPointMake(PROGRESS_BAR_HEIGHT / 2, self.bounds.size.height / 2);
    [path moveToPoint:point];
    CGPoint toPoint = CGPointMake(self.bounds.size.width - PROGRESS_BAR_HEIGHT / 2, self.bounds.size.height / 2);
    [path addLineToPoint:toPoint];

    progressLayer.path = path.CGPath;
    progressLayer.strokeColor = [UIColor whiteColor].CGColor;
    progressLayer.lineWidth = PROGRESS_BAR_HEIGHT - 6;
    progressLayer.lineCap = kCALineCapRound;
    [self.layer addSublayer:progressLayer];
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0f;
    pathAnimation.fromValue = @(0.0f);
    pathAnimation.toValue = @(1.0f);
    pathAnimation.delegate = self;
    [pathAnimation setValue:@"progressBarAnimation" forKey:@"animationName"];
    [progressLayer addAnimation:pathAnimation forKey:nil];
}

-(void)checkAnimation {
    CAShapeLayer *checkLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGRect rectInCircle = CGRectInset(self.bounds, self.bounds.size.width*(1-1/sqrt(2.0)) / 2, self.bounds.size.width*(1 - 1 / sqrt(2.0)) / 2);
    [path moveToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width / 9, rectInCircle.origin.y + rectInCircle.size.height * 2/3)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width / 3, rectInCircle.origin.y + rectInCircle.size.height * 9 / 10)];
    [path addLineToPoint:CGPointMake(rectInCircle.origin.x + rectInCircle.size.width * 8 / 10, rectInCircle.origin.y + rectInCircle.size.height * 2 / 10)];
    
    checkLayer.path = path.CGPath;
    checkLayer.fillColor = [UIColor clearColor].CGColor;
    checkLayer.strokeColor = [UIColor whiteColor].CGColor;
    checkLayer.lineWidth = 10.0;
    checkLayer.lineCap = kCALineCapRound;
    checkLayer.lineJoin = kCALineJoinRound;
    
    [self.layer addSublayer:checkLayer];
    
    CABasicAnimation *checkAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    checkAnimation.duration = 0.3f;
    checkAnimation.fromValue = @(0.0f);
    checkAnimation.toValue = @(1.0f);
    checkAnimation.delegate = self;
    [checkAnimation setValue:@"checkAnimation" forKey:@"animationName"];
    [checkLayer addAnimation:checkAnimation forKey:nil];
    
}

-(void)animationDidStart:(CAAnimation *)anim {
    if ([anim isEqual:[self.layer animationForKey:@"cornerRadiusShrinkAnim"]]) {
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, PROGRESS_BAR_WIDTH, PROGRESS_BAR_HEIGHT);
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self progressBarAnimation];
        }];
    } else if ([anim isEqual:[self.layer animationForKey:@"cornerRadiusExpandAnim"]]) {
        [UIView animateWithDuration:0.6f delay:0.0f usingSpringWithDamping:0.6 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.bounds = CGRectMake(0, 0, self.originFrame.size.width, self.originFrame.size.height);
            self.backgroundColor = [UIColor colorWithRed:0.1803921568627451 green:0.8 blue:0.44313725490196076 alpha:1.0];
        } completion:^(BOOL finished) {
            [self.layer removeAllAnimations];
            [self checkAnimation];
            self.animating = NO;
        }];
    }
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([[anim valueForKey:@"animationName"] isEqualToString:@"progressBarAnimation"]) {
        [UIView animateWithDuration:0.3 animations:^{
            for (CALayer *subLayer in self.layer.sublayers) {
                subLayer.opacity = 0.0f;
            }
        } completion:^(BOOL finished) {
            if (finished) {
                for (CALayer *subLayer in self.layer.sublayers) {
                    [subLayer removeFromSuperlayer];
                }
                
                self.layer.cornerRadius = self.originFrame.size.height / 2;
                
                CABasicAnimation *radiusAnimation = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
                radiusAnimation.duration = 0.2f;
                radiusAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
                radiusAnimation.fromValue = @(PROGRESS_BAR_HEIGHT / 2);
                radiusAnimation.delegate = self;
                [self.layer addAnimation:radiusAnimation forKey:@"cornerRadiusExpandAnim"];
            }
        }];
    } else if ([[anim valueForKey:@"animationName"] isEqualToString:@"checkAnimation"]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            for (CALayer *subLayer in self.layer.sublayers) {
                [subLayer removeFromSuperlayer];
            }
            self.backgroundColor = [UIColor blueColor];
        });
    }
}


@end
