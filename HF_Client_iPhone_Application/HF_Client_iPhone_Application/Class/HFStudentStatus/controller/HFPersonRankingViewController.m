//
//  HFPersonRankingViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/10.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFPersonRankingViewController.h"
#import "HFStudentModel.h"
#import "HFPersonRankingTableViewCell.h"

static NSString *ID = @"ID";

@interface HFPersonRankingViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong,nonatomic) UITableView *tableview;
@property (strong, nonatomic)NSMutableArray<HFStudentModel *> *studentArray; // 学生数组

@end

@implementation HFPersonRankingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLOR_ARGB(0xfff2f2f2);
    
    [self initUI];
    
    // 先查询数据库
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];  // 开放RLMRealm事务
    
    // 根据分数倒叙排行
    RLMResults *sortedModels = [[HFStudentModel allObjects] sortedResultsUsingKeyPath:@"point" ascending:NO];
    
    for (HFStudentModel *model in sortedModels) {
        NSLog(@"%@",model);

    }
    
    self.studentArray = (NSMutableArray<HFStudentModel *> *)sortedModels;
  
    [realm commitWriteTransaction]; // 提交事务
    
   
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

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.studentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HFPersonRankingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    

    HFStudentModel *model = self.studentArray[indexPath.row];
    cell.studentModel = model;
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

- (NSMutableArray<HFStudentModel *> *)studentArray{
    if (_studentArray == nil) {
        _studentArray = [NSMutableArray array];
    }
    
    return _studentArray;
}

@end
