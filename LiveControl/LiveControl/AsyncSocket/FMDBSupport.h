//
//  FMDBSupport.h
//  PatrolTask
//
//  Created by 艾则明 on 2016/12/10.
//  Copyright © 2016年 艾则明. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import <sqlite3.h>

@class FMResultSet;

@interface FMDBSupport : NSObject

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

+ (instancetype)sharedSupport;

- (void)FMDBSupportCreateDataBase;
- (BOOL)FMDBSupportExecuteUpdateWithContact:(NSString *)contact;
//- (FMResultSet*)FMDBSupportExecuteQueryWithContact:(NSString *)contact;

@end
