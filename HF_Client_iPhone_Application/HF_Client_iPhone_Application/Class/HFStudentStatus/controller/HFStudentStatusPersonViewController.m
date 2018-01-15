//
//  HFStudentStatusPersonViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2017/12/20.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFStudentStatusPersonViewController.h"
#import "HFTTeachToolCollectionViewCell.h"
#import "HFNetwork.h"
#import "WebServiceModel.h"
#import "HFStudentModel.h"
#import "HFStudentStatusRankingViewController.h"
#import <MBProgressHUD.h>
#import <Realm.h>

@interface HFStudentStatusPersonViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout,NSXMLParserDelegate>

@property (strong, nonatomic)NSString *currentElementName;
@property (strong, nonatomic)NSMutableArray<HFStudentModel *> *studentArray; // 学生数组

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property(strong,nonatomic) NSIndexPath *indexPath; // 选中的数据

@end

@implementation HFStudentStatusPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学生状态-个人";
    
    [self GetStudentListByClassID]; // 请求数据
    
    [self setupUI];
}

- (void)setupUI{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFTTeachToolCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(FLEXIBLE_WIDTH(60), 40); self.collectionView.collectionViewLayout = layout;
}

- (void)GetStudentListByClassID{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetStudentListByClassID";
    
    NSString *classId = [HFCacheObject shardence].classId;
    
    if (classId == nil) {
        NSLog(@"%@",@"classId为空");
        return;
        
    }
    
    if (classId.length >= 3) {
        classId =  [classId substringWithRange:NSMakeRange(0,3)];
    }
    
    if (classId.length != 0) {
        model.params = @{@"ClassID":classId}.mutableCopy;
    }
    
    NSString *url = [NSString stringWithFormat: @"%@%@", HOST, @"/webService/WisdomClassWS.asmx"];
    [[HFNetwork network] xmlSOAPDataWithUrl:url soapBody:[model getRequestParams] success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        self.studentArray = [[HFStudentModel new] getStudentGroup:responseObject];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

#pragma mark - UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择");
    // 设置为单选
    HFTTeachToolCollectionViewCell *cell;
    for(int i = 0 ; i < self.studentArray.count;i++){
        cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: [NSIndexPath indexPathForRow:i inSection:0]];
        if (cell != nil) {
            [cell setSelected:NO];
        }
        
    }
    cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    [cell setSelected:YES];
    
    // 记录选择的数据
    self.indexPath = indexPath;
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.studentArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFTTeachToolCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    cell.studentModel = self.studentArray[indexPath.row];
    return cell;
}



#pragma -mark 懒加载
- (NSMutableArray *)studentArray
{
    if (!_studentArray) {
        _studentArray = [NSMutableArray array];
    }
    return _studentArray;
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
- (IBAction)Ranking:(id)sender {
    NSLog(@"排行");
    HFStudentStatusRankingViewController *vc = [HFStudentStatusRankingViewController new];
    vc.rankType = @"个人";
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)addPoint:(NSInteger)point{
    
    if (self.indexPath == nil) {
        [self showText:@"请选择一名学生"];
        return;
    }
    
    [self showText:[NSString stringWithFormat:@"+%zd",point]];
    
    // 获取当前对象
    HFStudentModel *model =  self.studentArray[self.indexPath.item];
    NSLog(@"%@",model.userRealName);
    
    // 先查询数据库
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];  // 开放RLMRealm事务
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"userID = %@",model.userID];
    RLMResults *models = [HFStudentModel objectsWithPredicate:pred];
    // 如果有就添加分数
    if(models.count > 0){
        HFStudentModel *data = models[0];
        model.point = data.point;
    }
    model.point += point;
    
    // 增加或修改
    [HFStudentModel createOrUpdateInRealm:realm withValue:model];        // 添加到数据库 me为RLMObject
    
    pred = [NSPredicate predicateWithFormat:@"userID = %@",model.userID];
    models = [HFStudentModel objectsWithPredicate:pred];
    NSLog(@"%@",models[0]);
    
    [realm commitWriteTransaction]; // 提交事务
}

- (void)showText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Set the text mode to show only text.
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    // Move to bottm center.
//    hud.offset = CGPointMake(0.f, 100);
    
    [hud hideAnimated:YES afterDelay:2.f];
}

@end
