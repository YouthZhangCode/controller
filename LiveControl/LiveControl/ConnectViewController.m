//
//  ViewController.m
//  LiveControl
//
//  Created by fy on 2017/4/25.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "ConnectViewController.h"
#import "ZYLoseConnectionViewController.h"

#import "AsyncSocketManager.h"

NSString *const kLIVE_NEXT =   @"APP_REQ_NEXT_SCENE";
NSString *const kLIVE_SIGNUP = @"APP_REQ_MACHINE_SIGNUP_PLAYER";
NSString *const kLIVE_SWITCH = @"APP_REQ_SWITCH_PLAYER_LIVE_VIDEO";

@interface ConnectViewController ()<SocketReceiveMessageDelegate>

@property (nonatomic, strong) UITextField *IPTextField;
@property (nonatomic, strong) UIButton *connectButton;

@end

@implementation ConnectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    self.navigationController.navigationBar.translucent = NO;
    
    UIImage *barIamge = [[UIImage imageNamed:@"biaoqianlan"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImageView *barIamgeView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    barIamgeView.image = barIamge;
    [self.navigationController.navigationBar addSubview:barIamgeView];
    
    [[AsyncSocketManager sharedManager] socketConnectHost:hostIP port:SocketPort timeout:timeOut];
    
    [self createUI];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 40, 20)];
    button.backgroundColor = [UIColor purpleColor];
    [button addTarget:self action:@selector(presentVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)presentVC {
    ZYLoseConnectionViewController *lostVC = [[ZYLoseConnectionViewController alloc] init];
    [self presentViewController:lostVC animated:YES completion:nil];
}

- (void)createUI {
    
    CGFloat lineHeight = ScreenHeight*19.5/128.f;
    CGFloat addjustHeight = -10.f;
    
    for (int i = 0; i < 4; i++) {
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, ScreenHeight*7.2/128+i*lineHeight+addjustHeight, ScreenWidth*15/75, ScreenWidth*15/75)];
        NSString *imageName = [NSString stringWithFormat:@"headImage%d", i];
        UIImage *headImage = [UIImage imageNamed:imageName];
        headImageView.image = headImage;
        [self.view addSubview:headImageView];
        
        UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*37/75, ScreenHeight*11/128+i*lineHeight+addjustHeight, ScreenWidth*16/75, ScreenHeight*6/128)];
        [refreshButton setBackgroundImage:[UIImage imageNamed:@"shuaxinN"] forState:UIControlStateNormal];
        [refreshButton setBackgroundImage:[UIImage imageNamed:@"shuaxinS"] forState:UIControlStateHighlighted];
        refreshButton.adjustsImageWhenHighlighted = NO;

        [self.view addSubview:refreshButton];
        [refreshButton addTarget:self action:@selector(refreshButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        refreshButton.tag = 100+10*i+1;
        

        UIButton *switchButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*55/75, ScreenHeight*11/128+i*lineHeight+addjustHeight, ScreenWidth*16/75, ScreenHeight*6/128)];
        [switchButton setBackgroundImage:[UIImage imageNamed:@"qiehuanN"] forState:UIControlStateNormal];
        [switchButton setBackgroundImage:[UIImage imageNamed:@"qiehuanS"] forState:UIControlStateHighlighted];
        switchButton.adjustsImageWhenHighlighted = NO;

        [self.view addSubview:switchButton];
        [switchButton addTarget:self action:@selector(switchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        switchButton.tag = 100+10*i+2;
        
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth*11/75, ScreenHeight*24/128+i*lineHeight+addjustHeight, ScreenWidth*63/75, 1)];
        bottomLine.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:bottomLine];
    }
    
    for (int i = 0; i < 2; i++) {

        UIButton *nextStepButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth*12/75, ScreenHeight*(85.f/128+i*135.f/1280), ScreenWidth*51/75, ScreenHeight*86/1200)];
        nextStepButton.adjustsImageWhenHighlighted = NO;
        if (i == 0) {
            [nextStepButton setBackgroundImage:[UIImage imageNamed:@"fuweiN"] forState:UIControlStateNormal];
            [nextStepButton setBackgroundImage:[UIImage imageNamed:@"fuweiS"] forState:UIControlStateHighlighted];
            [nextStepButton setBackgroundColor:[UIColor lightGrayColor]];
            nextStepButton.userInteractionEnabled = NO;
        }else {
            [nextStepButton setBackgroundImage:[UIImage imageNamed:@"xiayibuN"] forState:UIControlStateNormal];
            [nextStepButton setBackgroundImage:[UIImage imageNamed:@"xiayibuS"] forState:UIControlStateHighlighted];
        }
        
        [nextStepButton addTarget:self action:@selector(nextStepButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        nextStepButton.tag = 200+i;
        [self.view addSubview:nextStepButton];
    }
    
}

- (void)refreshButtonClick:(UIButton *)button {
    NSNumber *index = [[NSNumber alloc] init];
    
    NSInteger tag = button.tag;
    switch (tag) {
        case 101:
            index = @1;
            break;
        case 111:
            index = @2;
            break;
        case 121:
            index = @3;
            break;
        case 131:
            index = @4;
            break;
        default:
            break;
    }
    
    NSDictionary *dict = @{@"cmd":kLIVE_SIGNUP, @"index":index};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [[AsyncSocketManager sharedManager] sendMessage:data];
}

- (void)switchButtonClick:(UIButton *)button {
    NSNumber *number = [[NSNumber alloc] init];
   
    switch (button.tag) {
        case 102:
            number = @1;
            break;
        case 112:
            number = @2;
            break;
        case 122:
            number = @3;
            break;
        case 132:
            number = @4;
            break;
            
        default:
            break;
    }
    
    NSDictionary *dict = @{@"index":number, @"cmd":kLIVE_SWITCH};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
     [[AsyncSocketManager sharedManager] sendMessage:data];
    
}

- (void)nextStepButtonClick:(UIButton *)button {
    NSDictionary *dict = @{@"cmd":kLIVE_NEXT};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    
    [[AsyncSocketManager sharedManager] sendMessage:data];
}

#pragma mark - 从SocketManager 回调到
- (void)onSocketReceiveDictionary:(NSDictionary *)dict {
    NSLog(@"收到服务器返回数据\n%@", dict);
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
