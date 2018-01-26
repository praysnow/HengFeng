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
#import "UIImageView+WebCache.h"

@interface HFClassTestShowViewController () <UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, HFClassTestCollectionViewCellDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) HFClassTestObject *object;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation HFClassTestShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.title = @"截屏测验";
    [self setupLayout];
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFClassTestCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];

    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(receviedCommitViewImage) name: @"CommitViewImage=" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reveviedForceCloseScreenTest) name: @"reveviedForceCloseScreenTest" object: nil];
    
}

- (void)setupLayout
{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_HEIGHT - 14 * 3) / 2, (SCREEN_HEIGHT - 14 * 3) / 2);
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - Notification

- (void)reveviedForceCloseScreenTest
{
    [self.navigationController popViewControllerAnimated: YES];
}

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
    cell.delegate = self;
    cell.object = [HFCacheObject shardence].commitViewArray[indexPath.row];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [HFCacheObject shardence].commitViewArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    for (HFClassTestCollectionViewCell *cell in collectionView.visibleCells) {
        cell.contentView.layer.borderColor = UICOLOR_ARGB(0xffe0e0e0).CGColor;
    }
    HFClassTestCollectionViewCell *cell = (HFClassTestCollectionViewCell *)[collectionView cellForItemAtIndexPath: indexPath];
    self.object = cell.object;
    cell.contentView.layer.borderColor = UICOLOR_ARGB(0xff53baa6).CGColor;
    NSLog(@"点击了哪个%zi", indexPath.row);
}

- (void)creatbuttonWhenClick
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.collectionView.width, self.collectionView.height)];
    [self.collectionView addSubview: imageView];
    [self.imageView sd_setImageWithURL: [NSURL URLWithString: [NSString stringWithFormat: @"http://%@%@", [HFNetwork network].SocketAddress, self.object.fileName]]];
    self.imageView = imageView;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addGestureWithImageView)];
    [imageView addGestureRecognizer: singleTap];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self addGestureWithImageView];
}

- (void)addGestureWithImageView
{
    [self.imageView removeFromSuperview];
    self.imageView = nil;
}

#pragma Cell Delegate

- (void)doubleClickCell:(HFClassTestObject *)object
{
    [self creatbuttonWhenClick];
}

#pragma mark - button click

- (IBAction)openImageView:(UIButton *)sender
{
    [self openImage];
}

- (IBAction)openVideoView:(UIButton *)sender
{
    [self openImage];
}

- (void)openImage
{
    if (self.imageView) {
        [self addGestureWithImageView];
    } else {
        [self creatbuttonWhenClick];
    }
}

@end
