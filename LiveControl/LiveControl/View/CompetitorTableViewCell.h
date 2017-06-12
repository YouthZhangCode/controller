//
//  CompetitorTableViewCell.h
//  LiveControl
//
//  Created by fy on 2017/6/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompetitorModel.h"


@interface CompetitorTableViewCell : UITableViewCell

@property (nonatomic, assign) CompetitorModelCondition condition;
@property (nonatomic, strong) CompetitorModel *competitor;

@property (nonatomic, copy) void (^deleteChoosenCompetitorBlock)(CompetitorModel *competitor);

- (void)configWithCompetitor:(CompetitorModel*)competitor;

@end
