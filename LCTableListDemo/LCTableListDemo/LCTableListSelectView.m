//
//  LCTableListSelectView.m
//  LCTableListDemo
//
//  Created by 刘成 on 17/1/17.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "LCTableListSelectView.h"
#import "XiaoCaiZhuHeader.h"

#define margin 5

@interface LCTableListSelectView () <UITableViewDelegate,UITableViewDataSource>
{
    UIButton *selectTopBtn;
    UIView *underLine;
    UIScrollView * mySrollView;
    NSArray *headArr;
}

@end

@implementation LCTableListSelectView

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    return self;
}

- (UIColor *)normalColor{
    if (!_normalColor) {
        self.normalColor = [UIColor blackColor];
    }
    return _normalColor;
}
- (UIColor *)selectColor{
    if (!_selectColor) {
        self.selectColor = [UIColor orangeColor];
    }
    return _selectColor;
}
- (UIColor *)lineColor{
    if (!_lineColor) {
        self.lineColor = [UIColor orangeColor];
    }
    return _lineColor;
}
- (CGFloat)headHeight{
    if (!_headHeight) {
        _headHeight = 45.0f;
    }
    return _headHeight;
}
- (NSInteger)selectIndex{

    if (!_selectIndex) {
        self.selectIndex = 0;
    }
    return _selectIndex;
}


- (void)createUI{

    headArr = @[@""];
    if ([self.dataSource respondsToSelector:@selector(numbersOfItemsWithTableListSelectView:)]) {
        headArr = [_dataSource numbersOfItemsWithTableListSelectView:self];
    }
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VW(self), self.headHeight)];
    headView.backgroundColor = [UIColor whiteColor];
    [self addSubview:headView];
    
    
    
    mySrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, FH(headView), VW(self)+margin, VH(self)-VH(headView))];
    mySrollView.showsHorizontalScrollIndicator = NO;
    mySrollView.bounces = NO;
    mySrollView.backgroundColor = [UIColor clearColor];
    mySrollView.contentSize = CGSizeMake(headArr.count*VW(mySrollView), VH(mySrollView));
    mySrollView.pagingEnabled = YES;
    mySrollView.delegate = self;
    [self addSubview:mySrollView];

    
    CGFloat btnW = VW(self)/headArr.count;
    for (int i=0; i<headArr.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*btnW, 0, btnW, VH(headView))];
        [btn setTitle:headArr[i] forState:UIControlStateNormal];
        [btn setTitleColor:self.normalColor forState:UIControlStateNormal];
        [btn setTitleColor:self.selectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(headBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 1000+i;
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        [headView addSubview:btn];
        
        if (i==self.selectIndex) {
            btn.selected = YES;
            selectTopBtn = btn;
            underLine = [[UIView alloc]initWithFrame:CGRectMake(VX(btn), VH(headView)-2, btnW, 2)];
            underLine.backgroundColor = self.lineColor;
            [headView addSubview:underLine];
        }
        
        if ([_dataSource respondsToSelector:@selector(tableViewOfItemsWithTableListSelectView:itemIndex:)]) {
            UITableView *tableView = [_dataSource tableViewOfItemsWithTableListSelectView:self itemIndex:i];
            tableView.frame = CGRectMake(i*VW(mySrollView), 0, VW(self), VH(mySrollView));
            tableView.tag = i+2000;
            tableView.delegate = self;
            tableView.dataSource = self;
            [mySrollView addSubview:tableView];
        }
        
    }
    
}

- (void)headBtnClick:(UIButton *)button{
    selectTopBtn.selected = NO;
    button.selected = YES;
    selectTopBtn = button;
    
    _selectIndex = button.tag-1000;
    UITableView *table = [self viewWithTag:_selectIndex+2000];
    [_delegate didSelectItemWithTableListSelectView:self tableView:table itemIndex:_selectIndex];

    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = underLine.frame;
        frame.origin.x = VX(button);
        underLine.frame = frame;
        
        mySrollView.contentOffset = CGPointMake(VW(mySrollView)*_selectIndex, 0);
    }];
}

#pragma mark UITableViewDelegate & dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger tag = tableView.tag - 2000;
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInTableView:tableListSelectView:itemIndex:)]) {
        NSInteger n = [_dataSource numberOfSectionsInTableView:tableView tableListSelectView:self itemIndex:tag];
        return n;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger tag = tableView.tag - 2000;
    if ([_dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:tableListSelectView:itemIndex:)]) {
        NSInteger n = [_dataSource tableView:tableView numberOfRowsInSection:section tableListSelectView:self itemIndex:tag];
        return n;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tag = tableView.tag - 2000;
    if ([_delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:tableListSelectView:itemIndex:)]) {
        CGFloat n = [_delegate tableView:tableView heightForRowAtIndexPath:indexPath tableListSelectView:self itemIndex:tag];
        return n;
    }
    return 0.1;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSInteger tag = tableView.tag - 2000;
    if ([_delegate respondsToSelector:@selector(tableView:heightForHeaderInSection:tableListSelectView:itemIndex:)]) {
        CGFloat n = [_delegate tableView:tableView heightForHeaderInSection:section tableListSelectView:self itemIndex:tag];
        return n;
    }
    return 0.1;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    NSInteger tag = tableView.tag - 2000;
    if ([_delegate respondsToSelector:@selector(tableView:heightForFooterInSection:tableListSelectView:itemIndex:)]) {
        CGFloat n = [_delegate tableView:tableView heightForFooterInSection:section tableListSelectView:self itemIndex:tag];
        return n;
    }
    return 0.1;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSInteger tag = tableView.tag - 2000;
    if ([_delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:tableListSelectView:itemIndex:)]) {
        UIView * n = [_delegate tableView:tableView viewForHeaderInSection:section tableListSelectView:self itemIndex:tag];
        return n;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    NSInteger tag = tableView.tag - 2000;
    if ([_delegate respondsToSelector:@selector(tableView:viewForFooterInSection:tableListSelectView:itemIndex:)]) {
        UIView * n = [_delegate tableView:tableView viewForFooterInSection:section tableListSelectView:self itemIndex:tag];
        return n;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tag = tableView.tag - 2000;
    if ([_dataSource respondsToSelector:@selector(tableView:cellForRowAtIndexPath:tableListSelectView:itemIndex:)]) {
        UITableViewCell * n = [_dataSource tableView:tableView cellForRowAtIndexPath:indexPath tableListSelectView:self itemIndex:tag];
        return n;
    }
    return [[UITableViewCell alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger tag = tableView.tag - 2000;
    if ([_delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:tableListSelectView:itemIndex:)]) {
        [_delegate tableView:tableView didSelectRowAtIndexPath:indexPath tableListSelectView:self itemIndex:tag];
    }
}

#pragma mark scrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == mySrollView) {
        
        CGFloat x = scrollView.contentOffset.x*VW(self)/(VW(mySrollView)*headArr.count);
        CGRect frame = underLine.frame;
        frame.origin.x = x;
        underLine.frame = frame;
        
        float width = VW(mySrollView);
        if (((int)scrollView.contentOffset.x % (int)width) == 0) {
            
            int n = scrollView.contentOffset.x / width;
            
            if (n!=_selectIndex) {
                UIButton *btn = [self viewWithTag:1000+n];
                [self headBtnClick:btn];
            }
        }
    }
}

- (void)refreshDataWithItemIndex:(NSInteger)itemIndex{
    UITableView *tableView = [self viewWithTag:2000+itemIndex];
    [tableView reloadData];
}

@end
