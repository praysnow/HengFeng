//
//  HFTeachToolViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/16.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFStutentStatusViewController.h"
#import "HFTTeachToolCollectionViewCell.h"

@interface HFStutentStatusViewController () <UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *sortButton;
@property (weak, nonatomic) IBOutlet UIButton *scoreButton;

@end

@implementation HFStutentStatusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFTTeachToolCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];
    [self setupLayout];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tabBarController.tabBar.hidden = NO;
}

- (void)setupLayout
{
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(FLEXIBLE_WIDTH(60), 60); self.collectionView.collectionViewLayout = layout;
}

#pragma mark - UICollectionViewDelegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 14, 0, 14);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFTTeachToolCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

@end
