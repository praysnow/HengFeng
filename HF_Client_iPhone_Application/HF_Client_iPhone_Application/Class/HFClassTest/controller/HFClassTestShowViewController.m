//
//  HFClassTestShowViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 20/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFClassTestShowViewController.h"
#import "HFClassTestCollectionViewCell.h"
#import "HFClassTestObject.h"

@interface HFClassTestShowViewController () <UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, HFClassTestCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) HFClassTestObject *object;

@end

@implementation HFClassTestShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.title = @"截屏测验";
    [self setupLayout];
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFClassTestCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receviedCommitViewImage) name: @"CommitViewImage=" object: nil];
}

- (void)setupLayout
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SCREEN_WIDTH / 2 - 14 * 3, 80);
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - CommitViewImage

- (void)receviedCommitViewImage
{
    //更新提交人数
    [self totalCountUpdate];
    [self.collectionView reloadData];
}

- (void)totalCountUpdate
{
    NSLog(@"总人数更新");
}

#pragma mark - UICollectionViewDeledate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(0,FLT_MIN);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 14, 0, 14);
}

#pragma mark - UICollectionDataSource

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    HFClassTestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
//    cell.object = [HFCacheObject shardence].commitViewArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return [HFCacheObject shardence].commitViewArray.count;
    return 12;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (HFClassTestCollectionViewCell *cell in collectionView.visibleCells) {
        cell.contentView.layer.borderColor = UICOLOR_ARGB(0xffe0e0e0).CGColor;
    }
    HFClassTestCollectionViewCell *cell = (HFClassTestCollectionViewCell *)[collectionView cellForItemAtIndexPath: indexPath];
    self.object = cell.object;
    cell.contentView.layer.borderColor = UICOLOR_ARGB(0xff53baa6).CGColor;
}

#pragma Cell Delegate

- (void)doubleClickCell:(HFClassTestObject *)object
{
    //    HFMySourcesDetailViewController *vc = [[HFMySourcesDetailViewController alloc] init];
    //    vc.object = object;
    //    [self.navigationController pushViewController: vc animated: YES];
}

#pragma mark - button click

- (IBAction)openImageView:(UIButton *)sender
{
    
}

- (IBAction)openVideoView:(UIButton *)sender
{
    
}

@end
