//
//  SingerChooseView.h
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>

//1、报名 2、签到 3、比赛中 4、展示歌手成绩 5、抽取幸运观众

typedef enum : NSInteger {
    SingerSigned,
    SingerUnsigned,
    SingerUnchoose
} SingerSignStatus;

typedef enum: NSInteger {
    CompetitionDurationSigning,
    CompetitionDurationPlaying
} CompetitionDutation;

@interface SingerChooseView : UIView

@property (nonatomic, copy) NSString *miniK, *singerName, *hearImageURL;
@property (nonatomic, assign) SingerSignStatus signStatus;
@property (nonatomic, assign) CompetitionDutation competitionDuration;
@property (nonatomic, strong) UIButton *leftButton, *rightButton;

- (instancetype)initWithFrame:(CGRect)frame competionDutatuon:(CompetitionDutation)duration;

@end
