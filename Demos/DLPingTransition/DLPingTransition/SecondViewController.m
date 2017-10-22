//
//  SecondViewController.m
//  DLPingTransition
//
//  Created by David on 2017/10/21.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "SecondViewController.h"

#import "FirstViewController.h"
#import "SecondViewController.h"
#import "PingInvertTransition.h"

@interface SecondViewController ()

@end

@implementation SecondViewController{
    UIPercentDrivenInteractiveTransition *percentTransition;
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
    return percentTransition;
}


-(void)edgePan:(UIPanGestureRecognizer *)recognizer{
    CGFloat per = [recognizer translationInView:self.view].x / (self.view.bounds.size.width);
    per = MIN(1.0,(MAX(0.0, per)));

    if (recognizer.state == UIGestureRecognizerStateBegan) {
        percentTransition = [[UIPercentDrivenInteractiveTransition alloc]init];
        [self.navigationController popViewControllerAnimated:YES];
    }else if (recognizer.state == UIGestureRecognizerStateChanged){
        [percentTransition updateInteractiveTransition:per];
    }else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled){
        if (per > 0.3) {
            [percentTransition finishInteractiveTransition];
        }else{
            [percentTransition cancelInteractiveTransition];
        }
        percentTransition = nil;
    }
}


- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPop) {
        PingInvertTransition *pingInvert = [PingInvertTransition new];
        return pingInvert;
    }else{
        return nil;
    }
}

- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}




@end
