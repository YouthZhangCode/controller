//
//  SingerSignViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "SingerSignViewController.h"
#import "CompetitionViewController.h"
#import "SingerChooseView.h"

@interface SingerSignViewController ()

@property (nonatomic, strong) UIButton *startCompetitionButton;

@end

@implementation SingerSignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AsyncSocketManager sharedManager].receiveMessageDelegate = self;
    self.customTitle = @"等待用户登录";
    [self createUI];
}

- (NSMutableArray *)competitorArray {
    if (!_competitorArray) {
        _competitorArray = [[NSMutableArray alloc] init];
    }
    return _competitorArray;
}

- (void)createUI {
    self.startCompetitionButton = [[UIButton alloc] initWithFrame:CGRectMake(60.f, ScreenHeight - 150.f, ScreenWidth - 120.f, 60.f)];
    self.startCompetitionButton.layer.cornerRadius = 30.f;
    self.startCompetitionButton.clipsToBounds = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"xiayibuanniu"];
    [self.startCompetitionButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.startCompetitionButton setTitle:@"开始比赛" forState:UIControlStateNormal];
    [self.startCompetitionButton addTarget:self action:@selector(startCompetitionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startCompetitionButton];
    
    //1334 750
    //730
    UIView *contenerView = [[UIView alloc] initWithFrame:CGRectMake(0, 74.f, ScreenWidth, ScreenHeight*730.f/1334.f)];
    contenerView.backgroundColor = RGB(250.f, 250.f, 250.f, 1.0);
    [self.view addSubview:contenerView];
    
    UIView *topBlank = [[UIView alloc] initWithFrame:CGRectMake(12.f*ScreenWidth/750.f, 25.f*ScreenHeight/1334.f, ScreenWidth*726.f/750.f, ScreenHeight*70.f/1334)];
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
    
    NSArray *miniKTitleArray = @[@"1号机", @"2号机", @"3号机", @"4号机"];
    
    for (int i = 0; i < 4; i++) {//728
        SingerChooseView *singerView = [[SingerChooseView alloc] initWithFrame:CGRectMake(12.f*ScreenWidth/750.f, 95.f*ScreenHeight/1334.f+i*150.f*ScreenHeight/1334.f, ScreenWidth*726.f/750.f, 150.f*ScreenHeight/1334.f) competionDutatuon:CompetitionDurationSigning miniKName:miniKTitleArray[i]];
        singerView.backgroundColor = [UIColor whiteColor];
        CompetitorModel *model = (CompetitorModel*)self.competitorArray[i];
        [singerView configWithCompetitor:model];
        [contenerView addSubview:singerView];
    }
}

- (void)startCompetitionButtonClicked {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"所用选手签到完成，开始比赛" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dic = @{@"cmd":APP_REQ_NEXT_SCENE, @"scene":@3};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        [[AsyncSocketManager sharedManager] sendMessage:data];
    }];
    UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:trueAction];
    [alertController addAction:falseAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onSocketReceiveDictionary:(NSDictionary *)dict {
    if (dict && [dict[@"cmd"] isEqualToString:APP_REQ_NEXT_SCENE]) {
//        if ([dict[@"ret"] isEqual:@1]) {
            CompetitionViewController *competitionVC = [[CompetitionViewController alloc] init];
//            [self presentViewController:competitionVC animated:YES completion:nil];
        [self.navigationController pushViewController:competitionVC animated:YES];
//        }else {
//            kTipAlert(@"中端机返回错误");
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
