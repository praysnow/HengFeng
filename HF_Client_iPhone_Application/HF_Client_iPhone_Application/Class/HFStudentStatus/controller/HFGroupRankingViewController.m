//
//  HFGroupRankingViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/12.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFGroupRankingViewController.h"
#import "HFStudentArrayModel.h"
#import "HFPersonRankingTableViewCell.h"

static NSString *ID = @"ID";

@interface HFGroupRankingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableview;
@property (strong, nonatomic)NSMutableArray<HFStudentArrayModel *> *studentGroupArray; // 小组数组

@end

@implementation HFGroupRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UICOLOR_ARGB(0xfff2f2f2);
    
    [self initUI];
    
    [self getData];
    
    [[HFSocketService sharedInstance] sendCtrolMessage:@[getEvaluateRank]];

}

- (void)initUI{
    
    UITableView *tableView = [UITableView new];
    self.tableview = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.frame = CGRectMake(20, 120, SCREEN_WIDTH - 40, SCREEN_HEIGHT- 44);
    [self.view addSubview:tableView];
    
    // 注册cell
    [tableView registerNib:[UINib nibWithNibName:@"HFPersonRankingTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
    
}

- (void)getData{
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];  // 开放RLMRealm事务

    // 先按PeopleGroupID查询数据库
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *PeopleGroupID = [defaults valueForKey:@"PeopleGroupID"];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"PeopleGroupID = %@",PeopleGroupID];
    RLMResults *models = [HFStudentArrayModel objectsWithPredicate:pred];

    // 对结果集按分数倒叙排行
    RLMResults *sortedModels = [models sortedResultsUsingKeyPath:@"point" ascending:NO];

    for (HFStudentArrayModel *model in sortedModels) {
        NSLog(@"%@",model);

    }

    self.studentGroupArray = (NSMutableArray<HFStudentArrayModel *> *)sortedModels;

    [realm commitWriteTransaction]; // 提交事务
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.studentGroupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HFPersonRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    HFStudentArrayModel *model = self.studentGroupArray[indexPath.row];
    cell.studentArrayModel = model;
    cell.numLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row + 1];

    if(indexPath.row == 0){
        cell.numImageView.hidden = NO;
        cell.numLabel.hidden = YES;
        cell.numImageView.image = [UIImage imageNamed:@"NO1"];
    }else if(indexPath.row == 1){
        cell.numImageView.hidden = NO;
        cell.numLabel.hidden = YES;
        cell.numImageView.image = [UIImage imageNamed:@"NO2"];
    }else if(indexPath.row == 2){
        cell.numImageView.hidden = NO;
        cell.numLabel.hidden = YES;
        cell.numImageView.image = [UIImage imageNamed:@"NO3"];
    }else{
        cell.numImageView.hidden = YES;
        cell.numLabel.hidden = NO;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (NSMutableArray<HFStudentArrayModel *> *)studentGroupArray{
    if (_studentGroupArray == nil) {
        _studentGroupArray = [NSMutableArray array];
    }
    return _studentGroupArray;
}

@end
