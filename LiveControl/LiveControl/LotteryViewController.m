//
//  LuckyDogViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "LotteryViewController.h"
#import "RegistionViewController.h"

@interface LotteryViewController ()

@property (nonatomic, strong) UIButton *lotteryButton, *nextRoundButton;

@end

@implementation LotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    self.customTitle = @"抽取幸运观众";
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 64.f, ScreenWidth, ScreenHeight -  64.f)];
    backgroundImageView.image = [UIImage imageNamed:@"choujiangbeijing"];
    [self.view addSubview:backgroundImageView];
    
    self.lotteryButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*(750.f-376.f)/750.f/2.f, 457.f/1334.f*ScreenHeight, ScreenWidth*376.f/750.f, ScreenWidth*376.f/750.f)];
    self.lotteryButton.layer.cornerRadius = ScreenWidth*376.f/750.f/2.f;
    self.lotteryButton.clipsToBounds = YES;
    UIImage *lotteryImage = [UIImage imageNamed:@"tingzhichouqu"];
    [self.lotteryButton setBackgroundImage:lotteryImage forState:UIControlStateNormal];
    [self.lotteryButton setTitle:@"开始抽奖" forState:UIControlStateNormal];
    [self.view addSubview:self.lotteryButton];
    
    self.nextRoundButton = [[UIButton alloc] initWithFrame:CGRectMake(60.f, ScreenHeight - 150.f, ScreenWidth - 120.f, 60.f)];
    self.nextRoundButton.layer.cornerRadius = 30.f;
    self.nextRoundButton.clipsToBounds = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"xiayibuanniu"];
    [self.nextRoundButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.nextRoundButton setTitle:@"下一轮" forState:UIControlStateNormal];
    [self.nextRoundButton addTarget:self action:@selector(nextRoundButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextRoundButton];
}

- (void)lotteryButtonClicked {
    NSLog(@"抽奖_____");
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
}

- (void)nextRoundButtonClicked {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否进入下一轮比赛？" preferredStyle:UIAlertControllerStyleAlert];
    __weak typeof(self) weakSelf = self;
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        RegistionViewController *registionVC = [[RegistionViewController alloc] init];
//        [weakSelf presentViewController:registionVC animated:YES completion:nil];
        [weakSelf.navigationController pushViewController:registionVC animated:YES];
    }];
    UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:trueAction];
    [alertController addAction:falseAction];
    [self presentViewController:alertController animated:YES completion:nil];
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
