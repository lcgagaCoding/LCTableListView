//
//  LCTableListSelectView.h
//  LCTableListDemo
//
//  Created by 刘成 on 17/1/17.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kWIDTH [UIScreen mainScreen].bounds.size.width
#define kHEIGHT [UIScreen mainScreen].bounds.size.height
#define VW(view) (view.frame.size.width)
#define VH(view) (view.frame.size.height)
#define VX(view) (view.frame.origin.x)
#define VY(view) (view.frame.origin.y)
#define FW(view) (VW(view)+VX(view))
#define FH(view) (VH(view)+VY(view))

@protocol LCTableListSelectViewDelegate;
@protocol LCTableListSelectViewDataSource;



@interface LCTableListSelectView : UIView

@property (strong, nonatomic) UIColor *normalColor;//头部默认颜色
@property (strong, nonatomic) UIColor *selectColor;//头部选中颜色
@property (strong, nonatomic) UIColor *lineColor;//底部线颜色


@property (assign, nonatomic) NSInteger selectIndex;//头部选中下标
@property (assign, nonatomic) CGFloat headHeight;//头部高度


@property (weak, nonatomic) id<LCTableListSelectViewDelegate>delegate;
@property (weak, nonatomic) id<LCTableListSelectViewDataSource>dataSource;

- (instancetype)initWithFrame:(CGRect)frame;

- (void)createUI;

- (void)refreshDataWithItemIndex:(NSInteger)itemIndex;


@end

@protocol LCTableListSelectViewDelegate <NSObject>

@optional
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

- (void)didSelectItemWithTableListSelectView:(LCTableListSelectView *)tableListSelectView tableView:(UITableView *)tableView itemIndex:(NSInteger)itemIndex;

@end


@protocol LCTableListSelectViewDataSource <NSObject>

@required

- (NSArray <NSString *> *)numbersOfItemsWithTableListSelectView:(LCTableListSelectView *)tableListSelectView;

- (UITableView *)tableViewOfItemsWithTableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

@optional

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex;

@end


