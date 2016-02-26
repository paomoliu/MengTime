//
//  LYRootViewController.m
//  MengTime
//
//  Created by paomoliu on 15/12/21.
//  Copyright © 2015年 Sunshine Girls. All rights reserved.
//

#import "LYRootViewController.h"

@interface LYRootViewController ()

@end

@implementation LYRootViewController

- (void)awakeFromNib
{
    self.contentViewScaleValue = 0.8;           //设置侧滑视图的缩放比例
    self.contentViewShadowEnabled = YES;        //设置侧滑时侧滑视图是否有阴影
    self.contentViewShadowRadius = 4.5;         //设置侧滑视图阴影的半径
    self.scaleContentView = YES;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
