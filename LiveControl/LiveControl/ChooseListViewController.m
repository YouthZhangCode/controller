//
//  ChooseListViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/8.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "ChooseListViewController.h"
#import "FMDBSupport.h"
#import "CompetitorModel.h"

@interface ChooseListViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (nonatomic, strong) UIImageView *searchBlank;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *doneButton, *cancleButton;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation ChooseListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.leftButton removeFromSuperview];
    [self.rightButton removeFromSuperview];
    
    self.customTitle = @"选择指定参赛选手";
    
    self.doneButton = [[UIButton alloc] initWithFrame:CGRectMake(12.f, 27.f, 40.f, 30.f)];
    [self.doneButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.doneButton];
   
    self.cancleButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth-92.f, 27.f, 80.f, 30.f)];
    [self.cancleButton setTitle:@"取消搜索" forState:UIControlStateNormal];
    [self.cancleButton addTarget:self action:@selector(cancleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancleButton];
    self.cancleButton.hidden = YES;
    
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.f, 64.f, ScreenWidth, 40.f)];
    self.searchBar.barTintColor = [UIColor redColor];
    [self.searchBar setDelegate:self];
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.f, 104.f, ScreenWidth, ScreenHeight-104.f) style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    
    [self loadTableViewData];
    [self testFMDBSupport];
    NSLog(@"home__%@", NSHomeDirectory());
}
- (NSMutableArray *)userSorting:(NSMutableArray *)modelArr {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSMutableArray *otherArray = [[NSMutableArray alloc] init];
    for (int i='A'; i<='Z'; i++) {
        NSMutableArray *rulesArray = [[NSMutableArray alloc] init];
        
        NSString *str1 = [NSString stringWithFormat:@"%c", i];
        for (int j=0; j<modelArr.count; j++) {
            CompetitorModel *model = [modelArr objectAtIndex:j];
            if ([model.firstLetter isEqualToString:str1]) {
                [rulesArray addObject:model];
                [otherArray addObject:model];
            }
        }
        if (rulesArray.count != 0) {
            [rulesArray insertObject:str1 atIndex:0];
            [array addObject:rulesArray];
        }
    }
    
    [modelArr removeObjectsInArray:otherArray];
    if (modelArr.count > 0) {
        [modelArr insertObject:@"#" atIndex:0];
        [array addObject:modelArr];
    }
    return array;
}


- (void)doneButtonClicked {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancleButtonClicked {
    [self.searchBar resignFirstResponder];
    self.cancleButton.hidden = YES;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)loadTableViewData {
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"user" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    if (error) {
        return;
    }
    NSArray *dataArray = [NSArray arrayWithArray:dict[@"data"]];
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in dataArray) {
        CompetitorModel *model = [[CompetitorModel alloc] init];
        model.name = dic[@"name"];
        model.uid = [NSString stringWithFormat:@"%@", dic[@"uid"]];
        model.avatar_url = dic[@"avatar_url"];
        model.competitorCondition = CompetitorModelConditionUnSelected;
        [mArr addObject:model];
    }
    self.dataArray = [self userSorting:mArr];
    
    [self.tableView reloadData];
}

- (void)testFMDBSupport {
    dispatch_queue_t sqliteQueue = dispatch_queue_create("sqlite", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    dispatch_async(sqliteQueue, ^{
        FMDBSupport *dbSupport = [FMDBSupport sharedSupport];
        
        NSLog(@"currentThread_____%@", [NSThread currentThread]);
        
        NSString *createTable = @"CREATE TABLE IF NOT EXISTS competitors(uid TEXT PRIMARY KEY NOT NULL, name TEXT NOT NULL, avatar_url TEXT)";
        [dbSupport FMDBSupportExecuteUpdateWithContact:createTable];
        
        for (NSArray *array in weakSelf.dataArray) {
            for (int i = 1; i < array.count; i++) {
                CompetitorModel *modle = (CompetitorModel *)array[i];
                NSString *insertString = [NSString stringWithFormat:@"INSERT INTO competitors(uid, name, avatar_url)VALUES('%@', '%@', '%@')", modle.uid, modle.name, modle.avatar_url];
                [dbSupport FMDBSupportExecuteUpdateWithContact:insertString];
            }
        }
    });
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray[section] count]-1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.dataArray[section][0];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CompetitorTableViewCell";
    CompetitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CompetitorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CompetitorModel *model = (CompetitorModel *)self.dataArray[indexPath.section][indexPath.row+1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configWithCompetitor:model];
    cell.condition = model.competitorCondition;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - tableView index
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *mArr = [[NSMutableArray alloc] init];
    for (NSArray *array in self.dataArray) {
        [mArr addObject:array[0]];
    }
    return mArr;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.mode = MBProgressHUDModeCustomView;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        hub.label.text = title;
        dispatch_async(dispatch_get_main_queue(), ^{
            [hub hideAnimated:YES afterDelay:.5];
        });
    });
    
    return index;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    NSLog(@"________%@", searchText);
    
    dispatch_queue_t searchQueue = dispatch_queue_create("sqliteSearch", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    dispatch_async(searchQueue, ^{
        FMDBSupport *dbSupport = [FMDBSupport sharedSupport];
        NSString *searchSql = [NSString stringWithFormat:@"SELECT * FROM competitors WHERE name LIKE '%%%@%%'", searchText];
        
        [dbSupport.dbQueue inDatabase:^(FMDatabase *db) {
            FMResultSet *resultSet = [[FMResultSet alloc] init];
            resultSet = [db executeQuery:searchSql];
            NSMutableArray *modelArr = [[NSMutableArray alloc] init];
            while ([resultSet next]) {
                CompetitorModel *model = [[CompetitorModel alloc] init];
                model.name = [resultSet stringForColumn:@"name"];
                model.uid = [resultSet stringForColumn:@"uid"];
                model.avatar_url = [resultSet stringForColumn:@"avatar_url"];
                [modelArr addObject:model];
            }
            weakSelf.dataArray = [weakSelf userSorting:modelArr];
            NSLog(@"___%@", weakSelf.dataArray);
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
        });
    });
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.cancleButton.hidden = NO;
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.searchBar resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
