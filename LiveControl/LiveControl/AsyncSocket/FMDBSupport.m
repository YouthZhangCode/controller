//
//  FMDBSupport.m
//  PatrolTask
//
//  Created by 艾则明 on 2016/12/10.
//  Copyright © 2016年 艾则明. All rights reserved.
//

#import "FMDBSupport.h"


static FMDBSupport *instance = nil;

@interface FMDBSupport()


@end

@implementation FMDBSupport


+ (instancetype)sharedSupport{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[FMDBSupport alloc] init];
            [instance FMDBSupportCreateDataBase];
        }
    });
        
    return instance;
}

- (void)FMDBSupportCreateDataBase{

    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePath = [doc stringByAppendingPathComponent:@"KShow.sqlite"];
    
     self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:filePath];
}

- (BOOL)FMDBSupportExecuteUpdateWithContact:(NSString *)contact{
    
    __block BOOL result;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:contact];
    }];
   
//开启事务
//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//        @try {
//            flag = [db executeUpdate:contact];
//        } @catch (NSException *exception) {
//            *rollback = YES;
//            flag = NO;
//        } @finally {
//            *rollback = !flag;
//        }//    }];

//    [self.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
//       
//        [db beginTransaction];
//        flag = [db executeUpdate:contact];
//        if (!flag) {
//            [db rollback];
//        }
//        [db commit];
//        
//    }];

    return result;
}

/**
 *  使用中会有问题
 */
- (FMResultSet*)FMDBSupportExecuteQueryWithContact:(NSString *)contact{
    
    __block FMResultSet *set = [[FMResultSet alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        set = [db executeQuery:contact];
    }];
    return set;
}




@end
