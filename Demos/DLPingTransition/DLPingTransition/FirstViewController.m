//
//  FirstViewController.m
//  DLPingTransition
//
//  Created by David on 2017/10/21.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "FirstViewController.h"
#import "PingTransition.h"
@interface FirstViewController ()

@end

@implementation FirstViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.delegate = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        
        PingTransition *ping = [[PingTransition alloc] init];
        return ping;
    }else{
        return nil;
    }
}


@end
