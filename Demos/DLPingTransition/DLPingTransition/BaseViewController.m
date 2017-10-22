//
//  BaseViewController.m
//  DLPingTransition
//
//  Created by David on 2017/10/22.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "BaseViewController.h"
#import "PingTransition.h"
#import "PingInvertTransition.h"

@interface BaseViewController ()

@property(nonatomic, strong) UIPercentDrivenInteractiveTransition *percentTransition;

@end

@implementation BaseViewController

-(BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIScreenEdgePanGestureRecognizer *edgeGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePan:)];
    edgeGes.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:edgeGes];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>) animationController {
    return self.percentTransition;
}

-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [self.percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (per > 0.3) {
            [self.percentTransition finishInteractiveTransition];
        }else{
            [self.percentTransition cancelInteractiveTransition];
        }
        self.percentTransition = nil;
    }
}

#pragma mark - UINavigationControllerDelegate
- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        PingTransition *ping = [[PingTransition alloc] init];
        return ping;
    }else if (operation == UINavigationControllerOperationPop){
        PingInvertTransition *pingInvert = [[PingInvertTransition alloc] init];
        return pingInvert;
    } else {
        return nil;
    }
}

@end
