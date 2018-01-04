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

@interface HFStudentStatusGroupViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout,NSXMLParserDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (strong, nonatomic)NSMutableArray *studentArray; // 学生数组

@end

@implementation HFStudentStatusGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title = @"学生状态-小组";
    
    // 请求分组情况
    [self setupUI];
}

- (void)setupUI{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 注册item
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFTTeachToolCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];
    
    // 注册headerView
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(FLEXIBLE_WIDTH(60), 60); self.collectionView.collectionViewLayout = layout;
}

- (void)GetGroupList{
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetGroupList";
    
    NSString *classId = [HFCacheObject shardence].classId;
    
    if (classId == nil) {
        NSLog(@"%@",@"classId为空");
        return;
        
    }
    if (classId.length != 0) {
        model.params = @{@"ClassID":classId}.mutableCopy;
    }
    
    NSString *url = [NSString stringWithFormat: @"%@%@", HOST, @"webService/WisdomClassWS.asmx"];
    [[HFNetwork network] xmlSOAPDataWithUrl:url soapBody:[model getRequestParams] success:^(id responseObject) {
        
        
        [responseObject setDelegate:self];
        [responseObject parse];
        NSLog(@"获取学生列表成功");
        
    } failure:^(NSError *error) {
        
    }];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 5;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    return CGSizeMake(200, 30);
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HFTTeachToolCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
//    cell.studentModel = self.studentArray[indexPath.row];
    return cell;
}

// 设置collectionview的头部
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
   UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    
    headerView.backgroundColor = [UIColor redColor];
    
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




#pragma -mark 懒加载
- (NSMutableArray *)studentArray{
    if (_studentArray == nil) {
        _studentArray = [NSMutableArray array];
    }
    return _studentArray;
}


@end
