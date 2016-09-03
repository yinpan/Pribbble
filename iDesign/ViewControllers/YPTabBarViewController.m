//
//  YPTabBarViewController.m
//  iDesign
//
//  Created by Yinpan on 16/2/25.
//  Copyright (c) 2016年 yinpans. All rights reserved.
//

#import "YPTabBarViewController.h"
#import "YPScanViewController.h"
#import "YPUserInfoViewController.h"
#import "YPBuketsViewController.h"



@interface YPTabBarViewController ()

@end

@implementation YPTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addRootViewControllers];

}

// 添加视图
- (void)addRootViewControllers
{
    
    
    self.tabBar.backgroundImage = [[UIImage alloc] init];
    self.tabBar.backgroundColor = [[UIColor themeWhiteColor] colorWithAlphaComponent:0.95];
    self.tabBar.tintColor = [UIColor themeColor];
    NSArray *VCTitleNamesArray = @[@"Shot",@"Buckets",@"Profile"];
    NSArray *VCImageNamesArray = @[@"dribbble",@"bukets",@"profile"];
    for (NSInteger i = 0; i < 3; i++) {
        UINavigationController *nav = nil;
        switch (i) {
            case 0:{
                YPScanViewController *scanVC = [[YPScanViewController alloc] init];
                scanVC.title = VCTitleNamesArray[i];
                [scanVC.tabBarItem setImage:[UIImage imageNamed:VCImageNamesArray[i]]];
                nav = [[UINavigationController alloc] initWithRootViewController:scanVC];
                break;
            }
            case 1:{
                YPBuketsViewController *butketsVC = [[YPBuketsViewController alloc] init];
                butketsVC.title = VCTitleNamesArray[i];
                [butketsVC.tabBarItem setImage:[UIImage imageNamed:VCImageNamesArray[i]]];
                nav = [[UINavigationController alloc] initWithRootViewController:butketsVC];
                break;
            }
            case 2:{
                YPUserInfoViewController *userVC = [[YPUserInfoViewController alloc] init];
                userVC.title = VCTitleNamesArray[i];
                userVC.isSelf = YES;
                [userVC.tabBarItem setImage:[UIImage imageNamed:VCImageNamesArray[i]]];
                nav = [[UINavigationController alloc] initWithRootViewController:userVC];
            }
            default:
                break;
        }
        
        [self addChildViewController:nav];
    }
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
