//
//  RootViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()<AsyncSocketDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBarHidden = YES;   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGB(238.f, 238.f, 238.f, 1.f);
    
    //收到连接成功的通知后设置代理，防止App启动时 服务器没启动 收不到代理回调
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSocketDelegate) name:@"didConnectToHost" object:nil];
    
   
    
    UIImageView *bottomImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    UIImage *bottomImage = [UIImage imageNamed:@"toububiaotilanbeijing"];
    bottomImageView.image = bottomImage;
    [self.view addSubview:bottomImageView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(70.f, 33.f, ScreenWidth - 140.f, 21.f)];
    [self.titleLabel setFont:[UIFont systemFontOfSize:20.f]];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:self.titleLabel];
    
    [self.leftButton setBackgroundImage:[UIImage imageNamed:@"fuweiicon"] forState:UIControlStateNormal];
    [self.leftButton addTarget:self action:@selector(restart) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setBackgroundImage:[UIImage imageNamed:@"qieshijiao"] forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(showAds:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setSocketDelegate {
    [AsyncSocketManager sharedManager].receiveMessageDelegate = self;
}

- (void)restart {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"是否确认重新开始？" preferredStyle:UIAlertControllerStyleAlert];
//    __weak typeof(self) weakSelf = self;
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dic = @{@"cmd":APP_REQ_RESET_SCENE};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        [[AsyncSocketManager sharedManager] sendMessage:data];
        
    }];
    UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:falseAction];
    [alertController addAction:trueAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showAds:(UIButton *)button {
    if (!button.selected) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否插播广告？" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.rightButton.selected = !weakSelf.rightButton.selected;
            NSDictionary *dic = @{@"cmd":APP_REQ_SHOW_OR_HIDE_VIDEO, @"type":@1};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            [[AsyncSocketManager sharedManager] sendMessage:data];
        }];
        UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:falseAction];
        [alertController addAction:trueAction];
        [self presentViewController:alertController animated:YES completion:nil];

    }else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否停止广告？" preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self) weakSelf = self;
        UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            weakSelf.rightButton.selected = !weakSelf.rightButton.selected;
            NSDictionary *dic = @{@"cmd":APP_REQ_SHOW_OR_HIDE_VIDEO, @"type":@0};
            NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
            [[AsyncSocketManager sharedManager] sendMessage:data];
        }];
        UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:falseAction];
        [alertController addAction:trueAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


- (UIButton *)rightButton {
    if (!_rightButton) {
        _rightButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 50.f, 27.f, 30.f, 30.f)];
        [self.view addSubview:_rightButton];
    }
    return _rightButton;
}

- (UIButton *)leftButton {
    if (!_leftButton) {
        _leftButton = [[UIButton alloc] initWithFrame:CGRectMake(20.f, 27.f, 30.f, 30.f)];
        [self.view addSubview:_leftButton];
    }
    return _leftButton;
}

- (void)setCustomTitle:(NSString *)customTitle {
    _customTitle = customTitle;
    self.titleLabel.text = _customTitle;
}

- (void)onSocketReceiveDictionary:(NSDictionary *)dict {
    
    if (dict && [dict[@"cmd"] isEqualToString:APP_REQ_RESET_SCENE]) {
        if ([dict[@"ret"] isEqual:@0]) {
            kTipAlert(@"复位返回错误");
        }
    }
    if (dict && [dict[@"cmd"] isEqualToString:APP_REQ_SHOW_OR_HIDE_VIDEO]) {
        if ([dict[@"ret"] isEqual:@0]) {
            kTipAlert(@"切换广告返回错误");
        }
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
