//
//  ViewController.m
//  DLCurveRefresh
//
//  Created by David on 2019/10/30.
//  Copyright © 2019 David. All rights reserved.
//

#import "ViewController.h"
#import "DLCurveView.h"


@interface ViewController ()

@property (nonatomic, strong) DLCurveView *curveView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    CGFloat windowWidth = [UIScreen mainScreen].bounds.size.width;
    
    self.curveView = [[DLCurveView alloc] init];
    self.curveView.frame = CGRectMake((windowWidth - 300) / 2, 300, 300, 150);
    [self.view addSubview:_curveView];
    
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake((windowWidth - 300) /2, 150, 300, 30)];
    [self.view addSubview:slider];
    
    [slider addTarget:self action:@selector(sliderValueChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)sliderValueChange:(UISlider *)slider {
    self.curveView.progress = slider.value;
    
    if (slider.value == 1.0) {
        _curveView.transform = CGAffineTransformIdentity;
         CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
         rotationAnimation.toValue = @(M_PI * 2.0);
         rotationAnimation.duration = 0.7f;
         rotationAnimation.autoreverses = NO;
         rotationAnimation.repeatCount = HUGE_VALF;
         rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
         [_curveView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    } else {
        [_curveView.layer removeAllAnimations];
    }
}


@end
