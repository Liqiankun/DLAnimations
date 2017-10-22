//
//  PingTransition.m
//  DLPingTransition
//
//  Created by David on 2017/10/21.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "PingTransition.h"
#import "FirstViewController.h"
#import "SecondViewController.h"

@interface PingTransition ()<CAAnimationDelegate>
@property (nonatomic,strong)id<UIViewControllerContextTransitioning> transitionContext;

@end

@implementation PingTransition


-(NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext{
    return 0.7f;
}

-(void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext{
    self.transitionContext = transitionContext;
    
    FirstViewController *firstVC = (FirstViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    SecondViewController *secondVC = (SecondViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *contentView = [transitionContext containerView];
    UIButton *button = firstVC.button;

    UIBezierPath *maskStartBP = [UIBezierPath bezierPathWithOvalInRect:button.frame];
    [contentView addSubview:firstVC.view];
    [contentView addSubview:secondVC.view];
    
    CGPoint finalPoint;
    if(button.frame.origin.x > (secondVC.view.bounds.size.width / 2)){
        if (button.frame.origin.y < (secondVC.view.bounds.size.height / 2)) {
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - CGRectGetMaxY(secondVC.view.bounds)+30);
        }else{
            finalPoint = CGPointMake(button.center.x - 0, button.center.y - 0);
        }
    }else{
        if (button.frame.origin.y < (secondVC.view.bounds.size.height / 2)) {
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(secondVC.view.bounds), button.center.y - CGRectGetMaxY(secondVC.view.bounds)+30);
        }else{
            finalPoint = CGPointMake(button.center.x - CGRectGetMaxX(secondVC.view.bounds), button.center.y - 0);
        }
    }
    
    CGFloat radius = sqrt((finalPoint.x * finalPoint.x) + (finalPoint.y * finalPoint.y));
    UIBezierPath *maskFinalBP = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(button.frame, -radius, -radius)];
    
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.path = maskFinalBP.CGPath;
    secondVC.view.layer.mask = maskLayer;

    CABasicAnimation *maskLayerAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    maskLayerAnimation.fromValue = (__bridge id)(maskStartBP.CGPath);
    maskLayerAnimation.toValue = (__bridge id)((maskFinalBP.CGPath));
    maskLayerAnimation.duration = [self transitionDuration:transitionContext];
    maskLayerAnimation.timingFunction = [CAMediaTimingFunction  functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    maskLayerAnimation.delegate = self;

    [maskLayer addAnimation:maskLayerAnimation forKey:@"path"];
}


- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    [self.transitionContext completeTransition:![self.transitionContext transitionWasCancelled]];
    [self.transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey].view.layer.mask = nil;
    [self.transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view.layer.mask = nil;
}

@end
