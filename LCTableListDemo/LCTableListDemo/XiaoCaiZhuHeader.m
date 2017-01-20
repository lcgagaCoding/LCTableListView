//
//  XiaoCaiZhuHeader.m
//  SmallRichMan
//
//  Created by 刘成 on 16/7/20.
//  Copyright © 2016年 小财主. All rights reserved.
//

#import "XiaoCaiZhuHeader.h"

@implementation XiaoCaiZhuHeader

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<10; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_animation_0%zd@2x.png", i]];
        [idleImages addObject:image];
    }
    [self setImages:idleImages forState:MJRefreshStateIdle];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 0; i<6; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_%zd@2x.png", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStatePulling];
    
    // 设置正在刷新状态的动画图片
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
