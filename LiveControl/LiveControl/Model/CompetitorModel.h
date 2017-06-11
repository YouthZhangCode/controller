//
//  CompetitorModel.h
//  LiveControl
//
//  Created by fy on 2017/6/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CompetitorModelCondition) {
    CompetitorModelConditionChoosen,   //选择页面 已指定
    CompetitorModelConditionUnchoosen, //选择页面 未指定
    CompetitorModelConditionSelected,  //列表页面 已选择
    CompetitorModelConditionUnSelected //列表页面 未选择
};

@interface CompetitorModel : NSObject

@property (nonatomic, copy) NSString *uid, *name, *avatar_url, *firstLetter;
@property (nonatomic, assign) CompetitorModelCondition competitorCondition;

@end
