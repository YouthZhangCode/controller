
//
//  ReconnectViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/11.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "ReconnectViewController.h"

@interface ReconnectViewController ()<MBProgressHUDDelegate>

@property (nonatomic, strong) UIImageView *connectionImageView;

@end

@implementation ReconnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rightButton.hidden = YES;
    self.leftButton.hidden = YES;
    self.customTitle = @"KShwo比赛控制器";
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 64.f, ScreenWidth, ScreenHeight-64.f)];
    UIImage *backgroundImage = [UIImage imageNamed:@"lianjiebeijing"];
    backgroundImageView.image = backgroundImage;
    [self.view addSubview:backgroundImageView];
    //750 1334 160 430 340
    self.connectionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*160.f/750.f, ScreenHeight*340.f/1334.f, ScreenWidth*430.f/750.f, ScreenWidth*430.f/750.f)];
    UIImage *loseConnectionImage = [UIImage imageNamed:@"duanwang"];
    self.connectionImageView.image = loseConnectionImage;
    [self.view addSubview:self.connectionImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didConnectToHost) name:@"didConnectToHost" object:nil];
    
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didConnectToHost {
    UIImage *connectImage = [UIImage imageNamed:@"lianjiechenggong"];
    self.connectionImageView.image = connectImage;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.text = @"连接成功!";
    [hud hideAnimated:YES afterDelay:1.0];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
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
