//
//  YPAddBuketViewController.m
//  iDesign
//
//  Created by Yinpan on 16/3/13.
//  Copyright © 2016年 yinpans. All rights reserved.
//

#import "YPAddBuketViewController.h"
#import "YPParamManager.h"
#import "YPAddBuketTableViewCell.h"
#import <YLImageView.h>

@interface YPAddBuketViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, strong)YPParamManager *paramManager;


@end

@implementation YPAddBuketViewController


- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (YPParamManager *)paramManager{
    if (_paramManager == nil) {
        _paramManager = [[YPParamManager alloc] init];
    }
    return _paramManager;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self loadBuketsData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor themeBarTinColor]};
}

- (void)createUI
{
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor themeBarTinColor]};
    
    self.view.backgroundColor = [UIColor themeCellGrayBackground];
    
    self.title = _shot.title;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addBuketType)];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 64) style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView registerNib:[UINib nibWithNibName:@"YPAddBuketTableViewCell" bundle:nil] forCellReuseIdentifier:@"CELL"];
    [self.view addSubview:_tableView];
    
    YLImageView *imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, WIDTH * 3 /4.0)];
    imageView.image = _sImage;
    _tableView.tableHeaderView = imageView;
}


- (void)loadBuketsData
{
    [YPFactory networkActivityIndicatorShow];
    [SVProgressHUD showWithStatus:@"Loading..."];
    [[YPFactory shareApiClient] loadBucketsWithUser:[YPFactory userDefaultsObjectForKey:KEY_USERID] params:[self.paramManager nowParams] responseHandler:^(DRApiResponse *response) {
        [YPFactory networkActivityIndicatorClose];
        [SVProgressHUD dismiss];
        if (response.object) {
            [self.dataArray addObjectsFromArray:response.object];
            [_tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
    }];
}




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPAddBuketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL" forIndexPath:indexPath];
    cell.shotId = _shot.shotId;
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 50)];
    view.backgroundColor = [UIColor themeCellGrayBackground];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 25, WIDTH - 20, 22)];
    label.text = @"Add Shot To Buket";
    label.font = [UIFont fontStandard];
    label.textColor = [UIColor themeFontGrayColor];
    [view addSubview:label];
    return view;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YPAddBuketTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.isAdd = !cell.isAdd;
}


- (void)addBuketType
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Create a buket" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"Title";
    }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"description";
    }];
    
    __weak typeof(self) weakSelf = self;
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [[YPFactory shareApiClient] addBucketWithParams:@{@"name":alert.textFields[0].text,@"description":alert.textFields[1].text} responseHandler:^(DRApiResponse *response) {
            if (response.object) {
                [weakSelf.dataArray addObject:response.object];
                [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataArray.count -1  inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
            }
        }];
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
