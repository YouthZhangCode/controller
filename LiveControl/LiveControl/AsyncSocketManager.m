//
//  AsyncSocketManager.m
//  LiveControl
//
//  Created by fy on 2017/4/26.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "AsyncSocketManager.h"
#import "ZYLoseConnectionViewController.h"
#import "ReconnectViewController.h"

@interface AsyncSocketManager ()<AsyncSocketDelegate>

@property (nonatomic, strong) NSTimer *heartbeatTimer;
@property (nonatomic, strong) NSTimer *connectTimer;

@property (nonatomic, strong) AsyncSocket *socket;

@property (nonatomic, assign) BOOL isConnected;

@end

@implementation AsyncSocketManager

+ (AsyncSocketManager *)sharedManager {
    static AsyncSocketManager *instanceType = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instanceType = [[self alloc] init];
    });
    return instanceType;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.isConnected = YES;
    }
    return self;
}


//- (AsyncSocket *)socket {
//    if (!_socket) {
//        _socket = [[AsyncSocket alloc] initWithDelegate:self];
//    }
//    return _socket;
//}

//连接
- (void)socketConnectHost:(NSString *)hostIPAddress port:(UInt16)port timeout:(CGFloat)timeout {
    if ([self.socket isConnected]) return;
    self.socket = [[AsyncSocket alloc] initWithDelegate:self];
    [self.socket connectToHost:hostIPAddress onPort:port withTimeout:timeout error:nil];
}

- (void)disconnect {
    if ([self.socket isConnected]) {
        [self.socket disconnect];
    }
}

- (void)sendMessage:(NSData *)data {
    [self.socket writeData:data withTimeout:3.0 tag:512];
    [self.socket readDataWithTimeout:2.0 tag:512];
}

#pragma mark - SocketDelegate

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
    NSLog(@"didConnectToHost");
    
    self.isConnected = YES;
    //开始发送心跳包
    [self.heartbeatTimer setFireDate:[NSDate distantPast]];
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
    NSLog(@"willDisconnectWithError_____error：%@", err);
}

//断开重连的时机？？？？ 以及对断开原因的分析？？？？
- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
    NSLog(@"SocketDidDisconnect");
    
    //停止发送心跳包
    [self.heartbeatTimer setFireDate:[NSDate distantFuture]];
    //开始重连
    if (self.isConnected == YES) {
        [self.connectTimer setFireDate:[NSDate distantPast]];
    }
    self.isConnected = NO;
    
    UIViewController *presentController = (UIViewController *)[UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    if (![presentController isKindOfClass:[ReconnectViewController class]]) {
        ReconnectViewController *reconnectionVC = [[ReconnectViewController alloc] init];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:reconnectionVC animated:YES completion:nil];
    }
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"didConnectToHost" object:nil];
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSLog(@"%@", dict);
    if (self.receiveMessageDelegate && [self.receiveMessageDelegate respondsToSelector:@selector(onSocketReceiveDictionary:)]) {
        [self.receiveMessageDelegate onSocketReceiveDictionary:dict];
    }
    
    //根据data数据判断是 1、推送来的，继续监听  2、请求的返回 return
    if (dict) {
        NSString *str = dict[@"cmd"];
        if ([str hasPrefix:@"APP"]) {
            return;
        }
    }
    [self.socket readDataWithTimeout:-1 tag:0];
}

//心跳包
- (void)sendHeartBeatPackage {
    NSDictionary *dict = @{@"cmd":@"APP_REQ_SHAKE_HANDS"};

    NSData *heartBeatData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    [self.socket writeData:heartBeatData withTimeout:2.0 tag:1024];
    [self.socket readDataWithTimeout:1.5 tag:1024];
}


- (NSTimer *)heartbeatTimer {
    if (!_heartbeatTimer) {
        _heartbeatTimer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(sendHeartBeatPackage) userInfo:nil repeats:YES];
        [_heartbeatTimer setFireDate:[NSDate distantPast]];
        [[NSRunLoop currentRunLoop] addTimer:_heartbeatTimer forMode:NSRunLoopCommonModes];
    }
    return _heartbeatTimer;
}

- (NSTimer *)connectTimer {
    if (!_connectTimer) {
        _connectTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(connectToHost) userInfo:nil repeats:YES];
        [_connectTimer setFireDate:[NSDate distantFuture]];
            [[NSRunLoop currentRunLoop] addTimer:self.connectTimer forMode:NSRunLoopCommonModes];
    }
    return _connectTimer;
}

- (void)connectToHost {
    [self socketConnectHost:hostIP port:SocketPort timeout:timeOut];
}

@end
