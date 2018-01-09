//
//  HFStudentStatusGroupViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/4.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFStudentStatusGroupViewController.h"
#import "HFTTeachToolCollectionViewCell.h"
#import "HFNetwork.h"
#import "WebServiceModel.h"
#import "HFStudentStatusRankingViewController.h"
#import "HFGroupModel.h"
#import "ZSSelectView.h"
#import "HFStudentArrayModel.h"
#import "HFStudentGroupCollectionReusableView.h"


@interface HFStudentStatusGroupViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout,NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic)NSMutableArray<HFGroupModel *> *groupModelArray; // 小组分组情况数组

@property (strong, nonatomic)ZSSelectView *selectView;

@property (strong, nonatomic)NSMutableArray<HFStudentModel *> *studentArray; // 学生数组

@property (strong, nonatomic)NSMutableArray<HFStudentArrayModel *> *studentGroupArray; // 小组数组

@end

@implementation HFStudentStatusGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"学生状态-小组";
    
    [self GetGroupList]; // 请求分组情况
    [self setupUI];
}

- (void)setupUI{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 注册item
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFTTeachToolCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];
    
    // 注册headerView
    [self.collectionView registerNib:[UINib nibWithNibName: NSStringFromClass([HFStudentGroupCollectionReusableView class]) bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.contentInset = UIEdgeInsetsMake(20, 0, 20, 0);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(FLEXIBLE_WIDTH(70), 40); self.collectionView.collectionViewLayout = layout;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(action:) name:@"HFStudentGroupCollectionReusableView" object:nil];
}

- (void)action:(NSNotification *)notification {
    NSLog(@"接受到通知%@",notification.object);
    NSString *num = notification.object;
    
    HFStudentArrayModel *model = self.studentGroupArray[[num intValue]];
    BOOL flag = model.isShow;
    
    for (HFStudentArrayModel *model in self.studentGroupArray) {
        model.isShow = NO;
    }
    
    
    model.isShow = !flag;
    [self.collectionView reloadData];
}

#pragma mark - 网络请求
// 请求有几个分组
- (void)GetGroupList{
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetGroupList";
    
    NSLog(@"classID:  %@",[HFCacheObject shardence].classId);
    NSString *classID = [HFCacheObject shardence].classId;
    if (classID.length >= 3) {
        classID =  [classID substringWithRange:NSMakeRange(0,3)];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"tpID"] = [HFCacheObject shardence].courseId;
    param[@"SubjectID"] = [HFCacheObject shardence].subjectId;
    param[@"ClassID"] = classID;
    param[@"userLoginName"] = @"wanglixia";
    
    NSLog(@"classID:  %@",[HFCacheObject shardence].classId);
    model.params = param;
    
    NSString *url = [NSString stringWithFormat: @"%@%@", HOST, @"/webService/WisdomClassWS.asmx"];
    [[HFNetwork network] xmlSOAPDataWithUrl:url soapBody:[model getRequestParams] success:^(id responseObject) {
        
        self.groupModelArray = [[HFGroupModel new] getGroupModelArray:responseObject];
        
    } failure:^(NSError *error) {
        
    }];
}

// 请求分组情况
- (void)GetGroupPeopleList:(NSString *)PeopleGroupID{
    
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetGroupPeopleList";
    
    model.params = @{@"PeopleGroupID":PeopleGroupID}.mutableCopy;
    
    NSString *url = [NSString stringWithFormat: @"%@%@", HOST, @"/webService/WisdomClassWS.asmx"];
    [[HFNetwork network] xmlSOAPDataWithUrl:url soapBody:[model getRequestParams] success:^(id responseObject) {
        
                
        self.studentArray = [[HFStudentModel new] getStudentGroup:responseObject];
        NSMutableDictionary<NSString *,HFStudentArrayModel *> *dic = [NSMutableDictionary dictionary];
        for (HFStudentModel *stu in self.studentArray) {
            
            if ([dic objectForKey:stu.PeopleGroupNum]) { // 是否包含这个小组
                [dic[stu.PeopleGroupNum].studentArray addObject:stu];
            }else{
                HFStudentArrayModel *studentArrayModel = [HFStudentArrayModel new];
                studentArrayModel.PeopleGroupNum = stu.PeopleGroupNum;
                dic[stu.PeopleGroupNum] = studentArrayModel;
                [dic[stu.PeopleGroupNum].studentArray addObject:stu];
            }
        }
        
//        NSLog(@"%@",dic);
        // 字典转为数组
        for(int i = 0;i<dic.count;i++){
            if ([dic objectForKey:[NSString stringWithFormat:@"%zd",i]]) {
                [self.studentGroupArray addObject:dic[[NSString stringWithFormat:@"%zd",i]]];
            }
        }
        NSLog(@"%@",self.studentGroupArray);
        
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.studentGroupArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    HFStudentArrayModel *model = self.studentGroupArray[section];
    
    if (model.isShow) {
        return self.studentGroupArray[section].studentArray.count;
    }else{
        return 0;
    }
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 30, 0, 30);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(200, 60);
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HFTTeachToolCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];

    HFStudentModel *stu =  self.studentGroupArray[indexPath.section].studentArray[indexPath.item];
    cell.studentModel = stu;
    
    return cell;
}

// 设置collectionview的头部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
   HFStudentGroupCollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
//    headerView.backgroundColor = [UIColor grayColor];

    HFStudentArrayModel *model = self.studentGroupArray[indexPath.section];
    headerView.model = model;
    

    return headerView;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    NSLog(@"选择");
    //    // 设置为单选
    //    HFTTeachToolCollectionViewCell *cell;
    //    for(int i = 0 ; i < self.studentArray.count;i++){
    //        cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: [NSIndexPath indexPathForRow:i inSection:0]];
    //        if (cell != nil) {
    //            [cell setSelected:NO];
    //        }
    //
    //    }
    //    cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    //    [cell setSelected:YES];
}



- (IBAction)groupButton:(id)sender {
    NSLog(@"小组");
    
    NSMutableArray *array = [NSMutableArray array];
    for (HFGroupModel *group in self.groupModelArray) {
        [array addObject:group.PeopleGroupName];
    }
    
    self.selectView = [ZSSelectView selectViewWithTitle:nil andContentArray:array andResultBlock:^(NSInteger index, NSString *result) {
        
        // 清空数据
        self.studentGroupArray = nil;
        [self GetGroupPeopleList:self.groupModelArray[index].PeopleGroupID];
    }];
    
    self.selectView.point = CGPointMake(0, SCREEN_HEIGHT - array.count * 50 - 60);
    [self.selectView show];
}
- (IBAction)add1:(id)sender {
    NSLog(@"+1");
}
- (IBAction)add2:(id)sender {
    NSLog(@"+2");
}
- (IBAction)add3:(id)sender {
    NSLog(@"+3");
}

- (IBAction)ranking:(id)sender {
    NSLog(@"排行");
    HFStudentStatusRankingViewController *vc = [HFStudentStatusRankingViewController new];
    vc.rankType = @"小组";
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma -mark 懒加载
- (NSMutableArray *)groupModelArray{
    if (_groupModelArray == nil) {
        _groupModelArray = [NSMutableArray array];
    }
    return _groupModelArray;
}

-(NSMutableArray<HFStudentModel *> *)studentArray{
    if (_studentArray == nil) {
        _studentArray = [NSMutableArray array];
    }
    
    return _studentArray;
}

- (NSMutableArray<HFStudentArrayModel *> *)studentGroupArray{
    if (_studentGroupArray == nil) {
        _studentGroupArray = [NSMutableArray array];
    }
    return _studentGroupArray;
}


@end
