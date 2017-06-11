//
//  ZYLoseConnectionViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "ZYLoseConnectionViewController.h"
#import "AsyncSocketManager.h"

@interface ZYLoseConnectionViewController ()



@end

@implementation ZYLoseConnectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, ScreenWidth - 100, 40)];
    tipLabel.backgroundColor = [UIColor cyanColor];
    tipLabel.text = @"断开连接，正在重连，请检查网络设置";
    [self.view addSubview:tipLabel];
    

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 60, 30)];
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectToHost) name:@"didConnectToHost" object:nil];
}

- (void)dismissVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didConnectToHost {
    [self dismissViewControllerAnimated:YES completion:nil];
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
