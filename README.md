# LCTableListView
仿头条首页多个tableView的滑动实现,基于tableView的二次封装,简单明了,集成简单
集成:导入#import "LCTableListSelectView.h"

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
    
    ![image](https://github.com/lcgagaCoding/LCTableListView/blob/master/Gift/LCTableListView.gif)
    
    
    
    
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

    - (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView tableListSelectView:(LCTableListSelectView *)tableListSelectView  itemIndex:(NSInteger)itemIndex{
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
