//
//  HFMyResourceViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/10.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFMyResourceViewController.h"

@interface HFMyResourceViewController ()<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HFMyResourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.delegate = self;
}

#pragma mark - UICollectionViewDeledate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected");
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [UICollectionViewCell new];
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 0;
}



@end
