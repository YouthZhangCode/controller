//
//  ChoosseSingerViewController.m
//  LiveControl
//
//  Created by fy on 2017/6/7.
//  Copyright © 2017年 LY. All rights reserved.
//

#import "ChoosseSingerViewController.h"
#import "SingerSignViewController.h"
#import "ChooseListViewController.h"
#import "CompetitorTableViewCell.h"

@interface ChoosseSingerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton *chooseCompetitorButton, *singerSignButton;
@property (nonatomic, strong) UILabel *choosenNumberLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ChoosseSingerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [AsyncSocketManager sharedManager].receiveMessageDelegate = self;
    
    [self createUI];
    [self loadTableViewData];
}

- (void)createUI {
    self.customTitle = @"选择比赛用户";
    
    self.singerSignButton = [[UIButton alloc] initWithFrame:CGRectMake(60.f, ScreenHeight - 150.f, ScreenWidth - 120.f, 60.f)];
    self.singerSignButton.layer.cornerRadius = 30.f;
    self.singerSignButton.clipsToBounds = YES;
    UIImage *buttonImage = [UIImage imageNamed:@"xiayibuanniu"];
    [self.singerSignButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
    [self.singerSignButton setTitle:@"确定比赛用户" forState:UIControlStateNormal];
    [self.singerSignButton addTarget:self action:@selector(startCompetitionButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.singerSignButton];
    
    UIView *conternerView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 74.f, ScreenWidth, 415.f)];
    conternerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:conternerView];
    
    UILabel *registionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.f, 30.f, 96.f, 13.f)];
    [registionTitleLabel setFont:[UIFont systemFontOfSize:12.f]];
    [registionTitleLabel setTextAlignment:NSTextAlignmentRight];
    registionTitleLabel.text = @"已报名用户数量:";
    [conternerView addSubview:registionTitleLabel];
    
    self.choosenNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.f, 26.f, 200.f, 17.f)];
    [self.choosenNumberLabel setFont:[UIFont systemFontOfSize:16.f]];
    [self.choosenNumberLabel setTextAlignment:NSTextAlignmentLeft];
    [self.choosenNumberLabel setTextColor:[UIColor blueColor]];
    self.choosenNumberLabel.text = @"0人";
    [conternerView addSubview:self.choosenNumberLabel];
    
    self.chooseCompetitorButton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/2.f - 100.f, 100.f, 200.f, 35.f)];
    self.chooseCompetitorButton.backgroundColor = [UIColor redColor];
    [self.chooseCompetitorButton setTitle:@"点此选择参赛选手(0/4)" forState:UIControlStateNormal];
    [self.chooseCompetitorButton addTarget:self action:@selector(chooseCompetitorButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [conternerView addSubview:self.chooseCompetitorButton];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.f, 180.f, ScreenWidth - 20.f, 200.f) style:UITableViewStylePlain];
    self.tableView.layer.borderWidth = 1.f;
    self.tableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [conternerView addSubview:self.tableView];
}

- (void)loadTableViewData {
    for (int i=0; i<4; i++) {
        CompetitorModel *model = [[CompetitorModel alloc] init];
        model.competitorCondition = CompetitorModelConditionUnchoosen;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)chooseCompetitorButtonClicked:(UIButton *)button {
    ChooseListViewController *chooseVC = [[ChooseListViewController alloc] init];
    [self presentViewController:chooseVC animated:YES completion:nil];
}

- (void)startCompetitionButtonClicked {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否选定参赛选手，进入签到环节？" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *trueAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSDictionary *dic = @{@"cmd":APP_REQ_NEXT_SCENE, @"scene":@2};
        NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        [[AsyncSocketManager sharedManager] sendMessage:data];
    }];
    UIAlertAction *falseAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:trueAction];
    [alertController addAction:falseAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)onSocketReceiveDictionary:(NSDictionary *)dict {
    
    if (dict && [dict[@"cmd"] isEqualToString:APP_REQ_NEXT_SCENE]) {
//        if ([dict[@"ret"] isEqual:@1]) {
            SingerSignViewController *singerSignVC = [[SingerSignViewController alloc] init];
//            [self presentViewController:singerSignVC animated:YES completion:nil];
        [self.navigationController pushViewController:singerSignVC animated:YES];
//        }else {
//            kTipAlert(@"中端机响应错误");
//        }
    }
}

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"CompetitorTableViewCell";
    CompetitorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CompetitorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    CompetitorModel *competitor = (CompetitorModel*)self.dataArray[indexPath.row];
    [cell configWithCompetitor:competitor];
    cell.condition = competitor.competitorCondition;
    return cell;
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
