//
//  StartViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "RegistionViewController.h"
#import "ChoosseSingerViewController.h"

@interface RegistionViewController ()

@property (nonatomic, strong) UIImageView *adImageView;

@property (nonatomic, strong) UIButton *startButton;

@end

@implementation RegistionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AsyncSocketManager sharedManager] socketConnectHost:hostIP port:SocketPort timeout:timeOut];
    [AsyncSocketManager sharedManager].receiveMessageDelegate = self;
    self.customTitle = @"开始报名";
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 64.f, ScreenWidth, ScreenHeight - 64.f)];
    backgroundImageView.image = [UIImage imageNamed:@"kaishibaimingbeijing"];
    [self.view addSubview:backgroundImageView];
    
    self.adImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.f, 64.f, ScreenWidth, ScreenHeight*2/5.f)];
    self.adImageView.image = [UIImage imageNamed:@"bannerad"];
    [self.view addSubview:self.adImageView];
    
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(60.f, ScreenHeight - 150.f, ScreenWidth - 120.f, 60.f)];
    UIImage *buttonImage = [UIImage imageNamed:@"xiayibuanniu"];
    [self.startButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.startButton setTitle:@"开始活动报名" forState:UIControlStateNormal];
    [self.startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startButton];
    
    UIButton *connectionButton = [[UIButton alloc] initWithFrame:CGRectMake(50, 300, 50, 50)];
    [connectionButton addTarget:self action:@selector(connect) forControlEvents:UIControlEventTouchUpInside];
    connectionButton.backgroundColor = [UIColor redColor];
    [self.view addSubview:connectionButton];
    
    UIButton *cutoffButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 300, 50, 50)];
    cutoffButton.backgroundColor = [UIColor yellowColor];
    [cutoffButton addTarget:self action:@selector(cutoff) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cutoffButton];
}

- (void)connect {
    [[AsyncSocketManager sharedManager] socketConnectHost:hostIP port:SocketPort timeout:timeOut];
}

- (void)cutoff {
    [[AsyncSocketManager sharedManager] disconnect];
}

- (BOOL)clearViewController {
    
    if (self.nextResponder) {
        UIViewController * vc = (UIViewController *)self.nextResponder;
        [vc removeFromParentViewController];
    }
    return [self clearViewController];
}

- (void)startButtonClicked {
    
    UIAlertController *alertControler = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否开始活动报名？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        NSDictionary *dic = @{@"cmd":APP_REQ_NEXT_SCENE,@"scene":@1};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        [[AsyncSocketManager sharedManager] sendMessage:data];
    }];
    UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertControler addAction:trueAction];
    [alertControler addAction:falseAction];
    [self presentViewController:alertControler animated:YES completion:nil];
}

#pragma mark - delegate
- (void)onSocketReceiveDictionary:(NSDictionary *)dict {
    
    if (dict && [dict[@"cmd"] isEqualToString:APP_REQ_NEXT_SCENE]) {
//        if ([dict[@"ret"]  isEqual: @1]) {
            ChoosseSingerViewController *chooseSingerVC = [[ChoosseSingerViewController alloc] init];
//            [self presentViewController:chooseSingerVC animated:YES completion:nil];
        [self.navigationController pushViewController:chooseSingerVC animated:YES];
            
//        }else {
//            kTipAlert(@"终端机响应错误");
//        }
    }
}

- (void)didReceiveMemoryWarning {

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
