//
//  CompetitionViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "CompetitionViewController.h"
#import "LotteryViewController.h"
#import "SingerChooseView.h"

@interface CompetitionViewController (){
    NSInteger _flag;
}

@property (nonatomic, strong) UIButton *goLotteryButton;
@property (nonatomic, strong) UISegmentedControl *screenControl;

@end

@implementation CompetitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AsyncSocketManager sharedManager].receiveMessageDelegate = self;
    
    self.customTitle = @"演唱比赛阶段";
    _flag = 0;
    
    [self createUI];
}

- (void)createUI {
    self.goLotteryButton = [[UIButton alloc] initWithFrame:CGRectMake(60.f, ScreenHeight - 150.f, ScreenWidth - 120.f, 60.f)];
    UIImage *buttonImage = [UIImage imageNamed:@"xiayibuanniu"];
    [self.goLotteryButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.goLotteryButton setTitle:@"显示选手成绩" forState:UIControlStateNormal];
    [self.goLotteryButton addTarget:self action:@selector(goLottery) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goLotteryButton];

    //1334 750
    //800
    UIView *contenerView = [[UIView alloc] initWithFrame:CGRectMake(0, 74.f, ScreenWidth, ScreenHeight*800.f/1334.f)];
    contenerView.backgroundColor = RGB(250.f, 250.f, 250.f, 1.0);
    [self.view addSubview:contenerView];
    
    
    self.screenControl = [[UISegmentedControl alloc] initWithFrame:CGRectMake(ScreenWidth/2.f-65.f, 15.f*ScreenHeight/1334.f, 130.f, 60.f*ScreenHeight/1334.f)];
    [self.screenControl insertSegmentWithTitle:@"一分屏" atIndex:0 animated:YES];
    [self.screenControl insertSegmentWithTitle:@"四分屏" atIndex:1 animated:YES];
    [self.screenControl addTarget:self action:@selector(switchScreen:) forControlEvents:UIControlEventValueChanged];
    self.screenControl.selectedSegmentIndex = 0;
    [self.screenControl setTintColor:[UIColor redColor]];
    [contenerView addSubview:self.screenControl];
    
    UIView *topBlank = [[UIView alloc] initWithFrame:CGRectMake(12.f*ScreenWidth/750.f, 90.f*ScreenHeight/1334.f, ScreenWidth*726.f/750.f, ScreenHeight*70.f/1334)];
    topBlank.backgroundColor = RGB(244.f, 244.f, 244.f, 1.0);
    topBlank.layer.borderWidth = 1.f;
    topBlank.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [contenerView addSubview:topBlank];
    
    UILabel *minikNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, ScreenHeight*20.f/1334.f, ScreenWidth*130.f/750.f, ScreenHeight*30.f/1334.f)];
    [minikNumberLabel setFont:[UIFont systemFontOfSize:ScreenHeight*28.f/1334.f]];
    [minikNumberLabel setTextAlignment:NSTextAlignmentCenter];
    [minikNumberLabel setTextColor:[UIColor lightGrayColor]];
    minikNumberLabel.text = @"机号";
    [topBlank addSubview:minikNumberLabel];
    
    UILabel *userNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(130.f*ScreenWidth/750.f, ScreenHeight*20.f/1334.f, ScreenWidth*254.f/750.f, ScreenHeight*30.f/1334.f)];
    [userNameLabel setFont:[UIFont systemFontOfSize:ScreenHeight*28.f/1334.f]];
    [userNameLabel setTextAlignment:NSTextAlignmentCenter];
    [userNameLabel setTextColor:[UIColor lightGrayColor]];
    userNameLabel.text = @"用户名";
    [topBlank addSubview:userNameLabel];
    
    UILabel *operationLabel = [[UILabel alloc] initWithFrame:CGRectMake(500.f*ScreenWidth/750.f, ScreenHeight*20.f/1334.f, ScreenWidth*140.f/750.f, ScreenHeight*30.f/1334.f)];
    [operationLabel setFont:[UIFont systemFontOfSize:ScreenHeight*28.f/1334.f]];
    [operationLabel setTextAlignment:NSTextAlignmentCenter];
    [operationLabel setTextColor:[UIColor lightGrayColor]];
    operationLabel.text = @"操作";
    [topBlank addSubview:operationLabel];
    
    NSArray *nameArray = @[@"1号机", @"2号机", @"3号机", @"4号机"];
    for (int i = 0; i < 4; i++) {//728
        SingerChooseView *singerView = [[SingerChooseView alloc] initWithFrame:CGRectMake(12.f*ScreenWidth/750.f, 160.f*ScreenHeight/1334.f+i*150.f*ScreenHeight/1334.f, ScreenWidth*726.f/750.f, 150.f*ScreenHeight/1334.f) competionDutatuon:CompetitionDurationPlaying miniKName:nameArray[i]];
        singerView.backgroundColor = [UIColor whiteColor];
        [contenerView addSubview:singerView];
    }
}

- (void)switchScreen:(UISegmentedControl *)sender {
    NSLog(@"%ld", sender.selectedSegmentIndex);
}

- (void)goLottery {
    if (_flag == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"所有选手演唱完成，显示选手成绩" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            NSDictionary *dic = @{@"cmd":APP_REQ_NEXT_SCENE, @"scene":@4};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            [[AsyncSocketManager sharedManager] sendMessage:data];
            
        }];
        UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:trueAction];
        [alertController addAction:falseAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否进入抽奖环节？" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof (self) weakSelf = self;
        UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            LotteryViewController *lotteryVC = [[LotteryViewController alloc] init];
//            [weakSelf presentViewController:lotteryVC animated:YES completion:nil];
            [weakSelf.navigationController pushViewController:lotteryVC animated:YES];
        }];
        UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:trueAction];
        [alertController addAction:falseAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)onSocketReceiveDictionary:(NSDictionary *)dict {
    if (dict && [dict[@"cmd"] isEqualToString:APP_REQ_NEXT_SCENE] && _flag == 0) {
//        if ([dict[@"ret"] isEqual:@1]) {
            [self.goLotteryButton setTitle:@"进入抽奖环节" forState:UIControlStateNormal];
            self.customTitle = @"选手名次";
            _flag = 1;
//        }else {
//            kTipAlert(@"中控机返回有误");
//        }
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
