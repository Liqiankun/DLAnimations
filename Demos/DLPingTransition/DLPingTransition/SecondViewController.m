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

@implementation SecondViewController

@dynamic button;

- (IBAction)popBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
