//
//  YPMenuViewController.m
//  iDesign
//
//  Created by Yinpan on 16/3/9.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPMenuViewController.h"
#import "YPMenuTableViewCell.h"
#import "YPMenuButton.h"

@interface YPMenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end
@implementation YPMenuViewController{
    UIView *_backView;
    NSMutableArray *dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *baseView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    baseView.backgroundColor = [[UIColor themeFontGrayColor] colorWithAlphaComponent:0.1];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)];
    [baseView addGestureRecognizer:tap];
    baseView.userInteractionEnabled = YES;
    [self.view addSubview:baseView];
    
    dataArray = [NSMutableArray array];
    if (!_isSort) {
        [dataArray addObjectsFromArray: @[@"Popular",@"Following",@"Debuts",@"Animated GIFs",@"Teams",@"PlayOffs"]];
        [self createLeftMenu];
    }else{

        NSArray *array = @[@"Recent",@"Popular",@"Most Viewed",@"Most Commented"];
        [dataArray addObject:array];
        NSArray *array1 = @[@"Now",@"The Post Week",@"The Post Month",@"The Post Year",@"All Time"];
        [dataArray addObject:array1];
        [self createRigthMenu];
    }
    
}

- (void)createRigthMenu
{
    _rightView = [[UIView alloc] initWithFrame:CGRectMake(WIDTH - 5 - WIDTH * 0.8 + 3, 55, WIDTH * 0.8 - 6, 300)];
    [self.view addSubview:_rightView];
    
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:_rightView.bounds];
    bgImageView.image = [[UIImage imageNamed:@"right_menu_bg"] stretchableImageWithLeftCapWidth:15 topCapHeight:15];
    [_rightView addSubview:bgImageView];
    
    CGRect rect = _rightView.bounds;
    rect.size.height -= 60;
    rect.origin.y += 20;
    rect.origin.x +=1;
    rect.size.width -=2;

    
    UITableView *tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor themeWhiteColor];
    [tableView registerNib:[UINib nibWithNibName:@"YPMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [_rightView addSubview:tableView];
    
    CALayer *layer = [[CALayer alloc] init];
    layer.frame = CGRectMake(0, CGRectGetMaxY(tableView.frame), CGRectGetWidth(_rightView.frame), 1);
    layer.backgroundColor = [UIColor themeCellGrayBackground].CGColor;
    [_rightView.layer addSublayer:layer];

    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(tableView.frame), 60, 40)];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_rightView addSubview:cancelButton];
    
    
    UIButton *updateButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(_rightView.frame) - 60, CGRectGetMaxY(tableView.frame), 60, 40)];
    [updateButton setTitle:@"Ok" forState:UIControlStateNormal];
    [updateButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [updateButton addTarget:self action:@selector(selectedFinished) forControlEvents:UIControlEventTouchUpInside];
    updateButton.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_rightView addSubview:updateButton];
    
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)createLeftMenu
{
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(5, 55, WIDTH * 0.8, 292)];
    [self.view addSubview:_leftView];
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:_leftView.bounds];
    bgImageView.image = [[UIImage imageNamed:@"left_menu_bg"] stretchableImageWithLeftCapWidth:35 topCapHeight:15];
    [_leftView addSubview:bgImageView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(3, 20, CGRectGetWidth(_leftView.frame) - 6, CGRectGetHeight(_leftView.frame) - 25 ) style:UITableViewStylePlain];
    tableView.scrollEnabled = NO;
    tableView.tableFooterView = [[UIView alloc] init];
    [tableView registerNib:[UINib nibWithNibName:@"YPMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [_leftView addSubview:tableView];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (!_isSort) {
        return 1;
    }
    if ([[YPFactory userDefaultsObjectForKey:KEY_MENU_SORT_POPULAR_SELECTEDINDEX] intValue]==0) {
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (!_isSort) {
        return dataArray.count;
    }
    return [dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    if (_isSort) {
        if (indexPath.section == 0 && [indexPath compare:[YPFactory shotMenuSortSelectedIndexPath][0]]==0) {
            cell.isSelected = YES;
        }else if (indexPath.section == 1 && [indexPath compare:[YPFactory shotMenuSortSelectedIndexPath][1]]==0) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
        cell.menuLabel.text = dataArray[indexPath.section][indexPath.row];
    }else{
        if ([indexPath compare:[YPFactory shotMenuTypeSelectedIndexPath][0]]==0) {
            cell.isSelected = YES;
        }else{
            cell.isSelected = NO;
        }
        cell.menuLabel.text = dataArray[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPMenuTableViewCell *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if (!cell.isSelected) {
        if (_isSort) {
            if (indexPath.section == 0) {
                [YPFactory userDefaultsSetObject:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:KEY_MENU_SORT_POPULAR_SELECTEDINDEX];
            }else{
                [YPFactory userDefaultsSetObject:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:KEY_MENU_SORT_TIME_SELECTEDINDEX];
            }
        }else{
            [YPFactory userDefaultsSetObject:[NSString stringWithFormat:@"%ld",indexPath.row] forKey:KEY_MENU_TYPE_SELECTEDINDEX];
            [self selectedFinished];
        }
        [tableView reloadData];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (!_isSort) {
        return 0;
    }
    return 25;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 40;
//}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"Popular";
    }else{
        return @"Time";
    }
}



- (void)selectedFinished
{
    self.selectedBlock(YES);
    [self back];
}

- (void)back
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
