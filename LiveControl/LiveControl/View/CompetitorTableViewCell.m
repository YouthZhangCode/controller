//
//  CompetitorTableViewCell.m
//  LiveControl
//
//  Created by fy on 2017/6/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "CompetitorTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface CompetitorTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *conditionImageView;

@end

@implementation CompetitorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10.f, 9.f, 32.f, 32.f)];
    self.headImageView.layer.cornerRadius = 16.f;
    self.headImageView.clipsToBounds = YES;
    [self.contentView addSubview:self.headImageView];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(52.f, 17.f, ScreenWidth-180.f, 15.f)];
    [self.nameLabel setFont:[UIFont systemFontOfSize:14.f]];
    [self.nameLabel setTextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.nameLabel];
    
    self.conditionImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 55.f, 12.f, 25.f, 25.f)];
    [self.contentView addSubview:self.conditionImageView];
}

- (void)configWithCompetitor:(CompetitorModel *)competitor {
    if (competitor.competitorCondition == CompetitorModelConditionUnchoosen) {
        self.headImageView.image = [UIImage imageNamed:@"morentouxiang"];
        [self.nameLabel setText:@"未选择"];
        [self.nameLabel setTextColor:[UIColor blueColor]];
    }else {
        NSURL *imageURL = [NSURL URLWithString:competitor.avatar_url];
        [self.headImageView sd_setImageWithURL:imageURL placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        [self.nameLabel setText:competitor.name];
        [self.nameLabel setTextColor:[UIColor blackColor]];
        
        if (competitor.competitorCondition == CompetitorModelConditionUnSelected) {
            [self setSelected:NO animated:NO];
        }else if (competitor.competitorCondition == CompetitorModelConditionSelected) {
            [self setSelected:YES animated:NO];
        }
    }
}

- (void)setCondition:(CompetitorModelCondition)condition {
    switch (condition) {
        case CompetitorModelConditionUnchoosen:
            self.conditionImageView.image = [UIImage imageNamed:@"jiahongquan"];
            break;
        case CompetitorModelConditionChoosen: {
            self.conditionImageView.image = [UIImage imageNamed:@"jianhongquan"];
            self.conditionImageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnDeleteImage)];
            [self.conditionImageView addGestureRecognizer:tap];
        }
            break;
        default:
            break;
    }
}

- (void)tapOnDeleteImage {
    if (_deleteChoosenCompetitorBlock) {
        _deleteChoosenCompetitorBlock(_competitor);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
