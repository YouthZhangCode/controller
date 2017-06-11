//
//  SingerChooseView.m
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "SingerChooseView.h"

@interface SingerChooseView ()

@property (nonatomic, strong) UILabel *miniKLabel, *signStatusLabael, *singerNameLabel;
@property (nonatomic, strong) UIImageView *headImageView;

@end

@implementation SingerChooseView


- (instancetype)initWithFrame:(CGRect)frame competionDutatuon:(CompetitionDutation)duration{
    self = [super initWithFrame:frame];
    self.competitionDuration = duration;
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    CGFloat height = self.bounds.size.height;
    CGFloat width = self.bounds.size.width;
    self.miniKLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*7.0/720, height*40.0/150, width*120.0/720, height*30.0/150)];
    [self.miniKLabel setFont:[UIFont systemFontOfSize:height*28.0/150]];
    [self.miniKLabel setTextAlignment:NSTextAlignmentCenter];
    self.miniKLabel.text = self.miniK;
    [self addSubview:self.miniKLabel];
    
   
    //155 64
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width*155.f/720.f, height*43.f/150.f, width*64.f/720.f, width*64.f/720.f)];
    self.headImageView.layer.cornerRadius = width*32.f/720.f;
    self.headImageView.clipsToBounds = YES;
    UIImage *headImage = [[UIImage imageNamed:@"morentouxiang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.headImageView.image = headImage;
    [self addSubview:self.headImageView];
    //226
    self.singerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(width*226.f/720.f, height*62.f/150.f, width*155.f/720.f, height*25.0/150)];
    [self.singerNameLabel setFont:[UIFont systemFontOfSize:height*24.f/150]];
    [self.singerNameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.singerNameLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:self.singerNameLabel];
    
    UIView *leftLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1.f, height)];
    leftLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:leftLine];
    UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, height-1.f, width, 1.f)];
    bottomLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:bottomLine];
    UIView *rightLine = [[UIView alloc] initWithFrame:CGRectMake(width-1.f, 0, 1.f, height)];
    rightLine.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:rightLine];
    
    //134 390 120
    UIView *middleLine1 = [[UIView alloc] initWithFrame:CGRectMake(width*134.f/720, height*15.f/150, 1.f, 120.f*height/150)];
    middleLine1.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:middleLine1];
    UIView *middleLine2 = [[UIView alloc] initWithFrame:CGRectMake(width*390.f/720, height*15.f/150, 1.f, 120.f*height/150.f)];
    middleLine2.backgroundColor = [UIColor lightGrayColor];
    [self addSubview:middleLine2];
    
    //对比赛阶段和演唱阶段进行判断
    if (self.competitionDuration == CompetitionDurationSigning) {
        self.signStatusLabael = [[UILabel alloc] initWithFrame:CGRectMake(width*7.0/720, height*90.f/150, width*120.f/720, height*25.0/150)];
        [self.signStatusLabael setFont:[UIFont systemFontOfSize:height*24.0/150]];
        [self.signStatusLabael setTextAlignment:NSTextAlignmentCenter];
        switch (self.signStatus) {
            case SingerSigned:
                [self.signStatusLabael setTextColor:[UIColor yellowColor]];
                self.signStatusLabael.text = @"已登录";
                break;
            case SingerUnsigned:
                [self.signStatusLabael setTextColor:[UIColor blackColor]];
                self.signStatusLabael.text = @"未登录";
                break;
            case SingerUnchoose:
                [self.signStatusLabael setTextColor:[UIColor lightGrayColor]];
                self.signStatusLabael.text = @"空  置";
                break;
            default:
                break;
        }
        [self addSubview:self.signStatusLabael];
        
        //135 70 412
        self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(width*412.f/720.f, height*40.f/150.f, width*135.f/720.f, height*70.f/150.f)];
        self.leftButton.layer.cornerRadius = 3.f;
        self.leftButton.clipsToBounds = YES;
        self.leftButton.layer.borderColor = [UIColor redColor].CGColor;
        self.leftButton.layer.borderWidth = 1.f;
        [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:height*27.f/150.f]];
        [self.leftButton setTitle:@"随机抽取" forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:self.leftButton];
        [self.leftButton addTarget:self action:@selector(leftButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        self.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(width*(412.f+135.f+24.f)/720.f, height*40.f/150.f, width*135.f/720.f, height*70.f/150.f)];
        self.rightButton.layer.cornerRadius = 3.f;
        self.rightButton.clipsToBounds = YES;
        self.rightButton.layer.borderColor = [UIColor redColor].CGColor;
        self.rightButton.layer.borderWidth = 1.f;
        [self.rightButton.titleLabel setFont:[UIFont systemFontOfSize:height*27.f/150.f]];
        [self.rightButton setTitle:@"指定用户" forState:UIControlStateNormal];
        [self.rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:self.rightButton];
        [self.rightButton addTarget:self action:@selector(rightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }else {
        self.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(width*504.f/720.f, height*40.f/150.f, width*135.f/720.f, height*70.f/150.f)];
        self.leftButton.layer.cornerRadius = 3.f;
        self.leftButton.clipsToBounds = YES;
        self.leftButton.layer.borderColor = [UIColor redColor].CGColor;
        self.leftButton.layer.borderWidth = 1.f;
        [self.leftButton.titleLabel setFont:[UIFont systemFontOfSize:height*27.f/150.f]];
        [self.leftButton setTitle:@"切换镜头" forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self addSubview:self.leftButton];
        [self.leftButton addTarget:self action:@selector(switchCamera:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.miniKLabel.text = @"N号机";
    self.singerNameLabel.text = @"用户AAA";
}


// Only override drawRect: if you perform custom drawing.
//An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {//720 150
//        
//   
//}

- (void)leftButtonClicked:(UIButton *)button {
    NSLog(@"______随机数抽取 方法空缺");
}

- (void)rightButtonClicked:(UIButton *)button {
    NSLog(@"_______指定选手 方法空缺");
}

- (void)switchCamera:(UIButton *)button {
    NSLog(@"_______切换镜头 方法空缺");
}






@end
