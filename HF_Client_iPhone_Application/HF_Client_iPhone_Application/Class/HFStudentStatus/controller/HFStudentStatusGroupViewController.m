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

@property (weak, nonatomic) IBOutlet UIButton *groupButton; // 分组按钮

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic)NSMutableArray<HFGroupModel *> *groupModelArray; // 小组分组情况数组

@property (strong, nonatomic)ZSSelectView *selectView;

@property (strong, nonatomic)NSMutableArray<HFStudentModel *> *studentArray; // 学生数组

@property (strong, nonatomic)NSMutableArray<HFStudentArrayModel *> *studentGroupArray; // 小组数组

@property(strong,nonatomic) HFStudentArrayModel *selectedStudentArrayModel; // 选中的小组

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
    self.selectedStudentArrayModel = model;
    
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
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetGroupList";
    
    NSString *classID = [HFCacheObject shardence].classId;
    if ([HFNetwork network].serverType == ServerTypeBeiJing && classID.length >= 3) {
        classID =  [classID substringWithRange:NSMakeRange(0,3)];
    }
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    NSString *url = nil;
    
    if ([HFNetwork network].serverType == ServerTypeBeiJing) {
        
        param[@"tpID"] = [HFCacheObject shardence].courseId;
        param[@"SubjectID"] = [HFCacheObject shardence].subjectId;
        param[@"ClassID"] = classID;
        param[@"userLoginName"] = @"wanglixia";
        
        url = [NSString stringWithFormat: @"%@%@%@",[HFNetwork network].ServerAddress, [HFNetwork network].WebServicePath, model.method];
    }else{
        
        param[@"arg0"] = @"tea01";
        param[@"arg1"] = classID;
        param[@"arg2"] =  [HFCacheObject shardence].subjectId;
        param[@"arg3"] = [HFCacheObject shardence].courseId;
        
        url = [NSString stringWithFormat: @"%@%@",[HFNetwork network].ServerAddress, [HFNetwork network].WebServicePath];
    }

    model.params = param;
    
    
    [[HFNetwork network] xmlSOAPDataWithUrl:url soapBody:[model getRequestParams] success:^(id responseObject) {
        
//        NSString *string = [[HFNetwork network] stringInNSXMLParser:responseObject];
//        NSLog(@"%@",string);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.groupModelArray = [[HFGroupModel new] getGroupModelArray:responseObject];

        // 请求最后一个分组
        if (self.groupModelArray.count > 0) {
            [self GetGroupPeopleList:[self.groupModelArray lastObject].PeopleGroupID];
            [self.groupButton setTitle:[self.groupModelArray lastObject].PeopleGroupName forState:UIControlStateNormal];

            // 保存数据
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setValue:[self.groupModelArray lastObject].PeopleGroupID forKey:@"PeopleGroupID"];
            [defaults setValue:[self.groupModelArray lastObject].PeopleGroupName forKey:@"PeopleGroupName"];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
}

// 请求分组情况
- (void)GetGroupPeopleList:(NSString *)PeopleGroupID{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetGroupPeopleList";
    
    NSString *url = nil;
    if ([HFNetwork network].serverType == ServerTypeBeiJing) {
        
        model.params = @{@"PeopleGroupID":PeopleGroupID}.mutableCopy;
        url = [NSString stringWithFormat: @"%@%@%@",[HFNetwork network].ServerAddress, [HFNetwork network].WebServicePath, model.method];
    }else{
        
        model.params = @{@"arg0":PeopleGroupID}.mutableCopy;
        url = [NSString stringWithFormat: @"%@%@",[HFNetwork network].ServerAddress, [HFNetwork network].WebServicePath];
    }
    
    [[HFNetwork network] xmlSOAPDataWithUrl:url soapBody:[model getRequestParams] success:^(id responseObject) {
        
//        NSString *string = [[HFNetwork network] stringInNSXMLParser:responseObject];
//        NSLog(@"%@",string);
         [MBProgressHUD hideHUDForView:self.view animated:YES];

        self.studentArray = [[HFStudentModel new] getStudentGroup:responseObject];
        NSMutableDictionary<NSString *,HFStudentArrayModel *> *dic = [NSMutableDictionary dictionary];
        for (HFStudentModel *stu in self.studentArray) {

            if ([dic objectForKey:stu.PeopleGroupNum]) { // 是否包含这个小组
                [dic[stu.PeopleGroupNum].studentArray addObject:stu];
            }else{
                HFStudentArrayModel *studentArrayModel = [HFStudentArrayModel new];
                studentArrayModel.PeopleGroupID = stu.PeopleGroupID;
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
        
         [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        
        // 保存数据
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:self.groupModelArray[index].PeopleGroupID forKey:@"PeopleGroupID"];
        [defaults setValue:self.groupModelArray[index].PeopleGroupName forKey:@"PeopleGroupName"];
        
        // 清空数据
        self.studentGroupArray = nil;
        [self GetGroupPeopleList:self.groupModelArray[index].PeopleGroupID];
        [self.groupButton setTitle:self.groupModelArray[index].PeopleGroupName forState:UIControlStateNormal];
    }];
    
    self.selectView.point = CGPointMake(0, SCREEN_HEIGHT - array.count * 50 - 60);
    [self.selectView show];
}
- (IBAction)add1:(id)sender {
    NSLog(@"+1");
    
    [self addPoint:1];
}
- (IBAction)add2:(id)sender {
    NSLog(@"+2");
    
    [self addPoint:2];
}
- (IBAction)add3:(id)sender {
    NSLog(@"+3");
    
    [self addPoint:3];
}

- (IBAction)ranking:(id)sender {
    NSLog(@"排行");
    HFStudentStatusRankingViewController *vc = [HFStudentStatusRankingViewController new];
    vc.rankType = @"小组";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addPoint:(NSInteger)point{
    
    if (self.selectedStudentArrayModel == nil) {
        [self showText:@"请选择一个小组"];
        return;
    }
    
    [self showText:[NSString stringWithFormat:@"+%zd",point]];
    
    // 获取当前对象
    HFStudentArrayModel *model = self.selectedStudentArrayModel;
//    NSLog(@"%@",model.userRealName);
    
    // 先查询数据库
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];  // 开放RLMRealm事务
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"keyID = %@",model.keyID];
    RLMResults *models = [HFStudentArrayModel objectsWithPredicate:pred];
    // 如果有就添加分数
    if(models.count > 0){
        HFStudentArrayModel *data = models[0];
        model.point = data.point;
        
        NSString *message = [NSString stringWithFormat:@"group_unfirst&%@&%@&%@",model.PeopleGroupID,model.PeopleGroupNum,@(point)];
        [[HFSocketService sharedInstance] sendCtrolMessage:@[sendGroupScoreToTeacher,message]];
    }else{
        NSString *message = [NSString stringWithFormat:@"group_first&%@&%@&%@",model.PeopleGroupID,model.PeopleGroupNum,@(point)];
        [[HFSocketService sharedInstance] sendCtrolMessage:@[sendGroupScoreToTeacher,message]];
    }
    model.point += point;
    
    // 增加或修改
    [HFStudentArrayModel createOrUpdateInRealm:realm withValue:model];        // 添加到数据库 me为RLMObject
    
    pred = [NSPredicate predicateWithFormat:@"keyID = %@",model.keyID];;
    models = [HFStudentArrayModel objectsWithPredicate:pred];
    NSLog(@"%@",models[0]);
    
    [realm commitWriteTransaction]; // 提交事务
}


- (void)showText:(NSString *)text {
    
    [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    // Move to bottm center.
    //    hud.offset = CGPointMake(0.f, 100);
    
    [hud hideAnimated:YES afterDelay:2.f];
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
