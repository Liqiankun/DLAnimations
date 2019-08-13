//
//  ViewController.m
//  DLJumpStar
//
//  Created by David on 2017/10/22.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import "ViewController.h"
#import "JumpStarView.h"
@interface ViewController ()

@property (weak, nonatomic) IBOutlet JumpStarView *jumpStarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_jumpStarView layoutIfNeeded];
    _jumpStarView.markedImage = [UIImage imageNamed:@"icon_star_incell"];
    _jumpStarView.non_markedImage = [UIImage imageNamed:@"blue_dot"];
    _jumpStarView.state = NONMark;

}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_jumpStarView animate];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
