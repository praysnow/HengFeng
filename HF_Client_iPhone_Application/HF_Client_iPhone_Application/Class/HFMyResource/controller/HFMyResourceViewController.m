//
//  HFMyResourceViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/10.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFMyResourceViewController.h"
#import "HFMyResourceCollectionViewCell.h"
#import "HFMyResourceHeaderFootView.h"
#import "HFNetwork.h"
#import "WebServiceModel.h"
#import "HFSocketService.h"
#import "HFCacheObject.h"

@interface HFMyResourceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)GCDAsyncSocket *socket;

@end

@implementation HFMyResourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFMyResourceCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];
    [self.collectionView registerNib: [UINib nibWithNibName: @"HFMyResourceHeaderFootView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.collectionView registerNib: [UINib nibWithNibName: @"HFMyResourceHeaderFootView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self setupLayout];
    [HFSocketService sharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(loadData) name: @"TEACHER_CTROL" object: nil];
}

- (void)loadData
{
    WebServiceModel *model = [[WebServiceModel alloc] init];
    model.method = @"GetDaoXueRenWuByTpID";
    HFCacheObject *object = [HFCacheObject shardence];
    model.params = [NSMutableDictionary dictionary];
    [model.params setValue: object.classId forKey: @"tpI"];
    [[HFNetwork network] SOAPDataWithSoapBody: [model getRequestParams] success:^(id responseObject) {
        NSLog(@"我的资源  请求结果为%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"我的资源  请求结果失败");
        NSLog(@"loadData faild %@",error.userInfo);
    }];
}

- (void)setupLayout
{
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(FLEXIBLE_WIDTH(100), 100);
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - UICollectionViewDeledate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
    return CGSizeMake(0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 100;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
    return CGSizeMake(0,10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 14, 0, 14);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self loadData];
    NSLog(@"点击");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFMyResourceCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HFMyResourceHeaderFootView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HFMyResourceHeaderFootView *headerFooterView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"HeaderView" forIndexPath: indexPath];
        //        headerFooterView.delegate = self;
        reusableView = headerFooterView;
    }
    reusableView.backgroundColor = [UIColor whiteColor];
    if (kind == UICollectionElementKindSectionFooter)
    {
        HFMyResourceHeaderFootView *headerFooterView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier: @"FooterView" forIndexPath: indexPath];
        if (indexPath.section == 3) {
            headerFooterView.hidden = NO;
        } else {
            headerFooterView.hidden = YES;
        }
        reusableView = headerFooterView;
    }
    return reusableView;
}

@end
