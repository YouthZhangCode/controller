//
//  SingerChooseView.h
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompetitorModel.h"

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

//@property (nonatomic, copy) NSString *miniK, *singerName, *hearImageURL;
//@property (nonatomic, assign) SingerSignStatus signStatus;

@property (nonatomic, assign) CompetitionDutation competitionDuration;

- (instancetype)initWithFrame:(CGRect)frame competionDutatuon:(CompetitionDutation)duration miniKName:(NSString *)name;
- (void)configWithCompetitor:(CompetitorModel *)competitor;

@end
