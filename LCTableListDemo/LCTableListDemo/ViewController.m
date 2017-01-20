//
//  ViewController.m
//  LCTableListDemo
//
//  Created by 刘成 on 17/1/17.
//  Copyright © 2017年 刘成. All rights reserved.
//

#import "ViewController.h"
#import "LCTableListSelectView.h"
#import "XiaoCaiZhuHeader.h"
#import "MJRefresh.h"

//RGB的颜色转换
#define kUIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface ViewController ()<LCTableListSelectViewDelegate,LCTableListSelectViewDataSource>
{
    NSInteger selectIndex;
    UITableView *selectTableView;

}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    LCTableListSelectView *tableListSelectView = [[LCTableListSelectView alloc]initWithFrame:CGRectMake(0, 64, kWIDTH, kHEIGHT-64)];
    tableListSelectView.selectIndex = selectIndex;
    tableListSelectView.delegate = self;
    tableListSelectView.dataSource = self;
    tableListSelectView.normalColor = kUIColorFromRGB(0x454545);
    tableListSelectView.selectColor = kUIColorFromRGB(0xf36342);
    tableListSelectView.lineColor = kUIColorFromRGB(0xf36342);
    [tableListSelectView createUI];
    tableListSelectView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tableListSelectView];

}

- (NSArray<NSString *> *)numbersOfItemsWithTableListSelectView:(LCTableListSelectView *)tableListSelectView{
    return @[@"哈哈",@"呵呵",@"啊啊"];
}

- (UITableView *)tableViewOfItemsWithTableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    tableView.showsVerticalScrollIndicator=NO;
    tableView.backgroundColor = [UIColor clearColor];
    XiaoCaiZhuHeader *header = [XiaoCaiZhuHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    header.lastUpdatedTimeLabel.hidden = YES;
    header.stateLabel.hidden = YES;
    tableView.mj_header = header;
    tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    
    if (itemIndex == selectIndex) {
        [tableView.mj_header beginRefreshing];
        selectTableView = tableView;
        
    }
    return tableView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex{
    if (itemIndex==0) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex{
    if (itemIndex==0) {
        return 5;
    }
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex{
    if (itemIndex==0) {
        return 30;
    }
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex{
    if (itemIndex==0) {
        return 20;
    }
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWIDTH, 40)];
    view.backgroundColor = [UIColor yellowColor];

    if (itemIndex==0) {
        view.backgroundColor = [UIColor blueColor];
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath tableListSelectView:(LCTableListSelectView *)tableListSelectView itemIndex:(NSInteger)itemIndex{
    
    if (itemIndex==0) {
        static NSString *cellId = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%zi组%zi行",indexPath.section,indexPath.row];
        return cell;
    }
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%zi行%zi组",indexPath.row,indexPath.section];
    return cell;
    
}

- (void)didSelectItemWithTableListSelectView:(LCTableListSelectView *)tableListSelectView tableView:(UITableView *)tableView itemIndex:(NSInteger)itemIndex{
    NSLog(@"%zi",itemIndex);
    selectTableView = tableView;
    selectIndex = itemIndex;
    [self refreshData];
}


- (void)refreshData{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [selectTableView.mj_header endRefreshing];
 
    });
}

- (void)loadMoreData{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [selectTableView.mj_footer endRefreshing];
        
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
