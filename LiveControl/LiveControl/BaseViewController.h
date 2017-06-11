//
//  RootViewController.h
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncSocketManager.h"

@interface BaseViewController : UIViewController<SocketReceiveMessageDelegate>

@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, copy) NSString *customTitle;

@end
