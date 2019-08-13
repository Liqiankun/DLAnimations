//
//  JumpStarView.h
//  DLJumpStar
//
//  Created by David on 2017/10/22.
//  Copyright © 2017年 FT_David. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NONMark,
    Mark,
}STATE;

@interface JumpStarView : UIView

-(void)animate;

@property(nonatomic,assign,setter=setState:)STATE state;
@property(nonatomic,strong)UIImage *markedImage;
@property(nonatomic,strong)UIImage *non_markedImage;

@end
