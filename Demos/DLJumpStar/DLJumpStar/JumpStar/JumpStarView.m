//
//  JumpStarView.m
//  DLJumpStar
//
//  Created by David on 2017/10/22.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "JumpStarView.h"


#define jumpDuration 0.125
#define downDuration 0.215

@interface JumpStarView ()<CAAnimationDelegate>

@property(nonatomic, assign) BOOL animating;
@property(nonatomic,strong) UIImageView *starView;
@property(nonatomic,strong) UIImageView *shadowView;

@end

@implementation JumpStarView

-(void)layoutSubviews{
    
    [super layoutSubviews];
    self.backgroundColor = [UIColor clearColor];
    if (self.starView == nil) {
        self.starView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - (self.bounds.size.width-6)/2, 0, self.bounds.size.width-6, self.bounds.size.height - 6)];
        self.starView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.starView];
    }
    if (self.shadowView == nil) {
        self.shadowView = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.size.width/2 - 10/2, self.bounds.size.height - 3, 10, 3)];
        self.shadowView.image = [UIImage imageNamed:@"shadow_new"];
        [self addSubview:self.shadowView];
    }
    
}

-(void)animate {
    if (self.animating) {
        return;
    }
    
    self.animating = YES;
    
    CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    transformAnimation.fromValue = @(0);
    transformAnimation.toValue = @(M_PI_2);
    transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnimation.fromValue = @(self.starView.center.y);
    positionAnimation.toValue = @(self.starView.center.y - 14);
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = jumpDuration;
    animationGroup.fillMode = kCAFillModeForwards;
    animationGroup.removedOnCompletion = NO;
    animationGroup.delegate = self;
    animationGroup.animations = @[transformAnimation, positionAnimation];
    
    [self.starView.layer addAnimation:animationGroup forKey:@"jumpUp"];
}

- (void)animationDidStart:(CAAnimation *)anim{
    
    if ([anim isEqual:[self.starView.layer animationForKey:@"jumpUp"]]) {
        [UIView animateWithDuration:jumpDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            _shadowView.alpha = 0.2;
            _shadowView.bounds = CGRectMake(0, 0, _shadowView.bounds.size.width*1.6, _shadowView.bounds.size.height);
        } completion:NULL];
        
    }else if ([anim isEqual:[self.starView.layer animationForKey:@"jumpDown"]]){
        
        [UIView animateWithDuration:jumpDuration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            _shadowView.alpha = 0.4;
            _shadowView.bounds = CGRectMake(0, 0, _shadowView.bounds.size.width/1.6, _shadowView.bounds.size.height);
            
        } completion:NULL];
        
    }
}

-(void)setState:(STATE)state{
    _state = state;
    self.starView.image = _state==Mark? _markedImage : _non_markedImage;
}


-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim isEqual:[self.starView.layer animationForKey:@"jumpUp"]]) {
        self.state = self.state == Mark ? NONMark : Mark;
        
        CABasicAnimation *transformAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        transformAnimation.fromValue = @(M_PI_2);
        transformAnimation.toValue = @(M_PI);
        transformAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        
        CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.y"];
        positionAnimation.fromValue = @(self.starView.center.y - 14);
        positionAnimation.toValue = @(self.starView.center.y);
        positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
        
        CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
        animationGroup.duration = downDuration;
        animationGroup.fillMode = kCAFillModeForwards;
        animationGroup.removedOnCompletion = NO;
        animationGroup.delegate = self;
        animationGroup.animations = @[transformAnimation, positionAnimation];
        
        [self.starView.layer addAnimation:animationGroup forKey:@"jumpDown"];
    } else if ([anim isEqual:[self.starView.layer animationForKey:@"jumpDown"]]) {
        [self.starView.layer removeAllAnimations];
        self.animating = NO;
    }
}

@end
