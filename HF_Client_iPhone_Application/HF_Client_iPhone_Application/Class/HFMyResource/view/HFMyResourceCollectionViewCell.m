//
//  HFMyResourceCollectionViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/15.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFMyResourceCollectionViewCell.h"


@interface HFMyResourceCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation HFMyResourceCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.borderColor = UICOLOR_ARGB(0xffe0e0e0).CGColor;
    self.contentView.layer.borderWidth = 2.0f;
    UITapGestureRecognizer *doubleTabGesture=[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleDoubleTap:)];
    [doubleTabGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer:doubleTabGesture];
}

- (void)handleDoubleTap: (UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector: @selector(doubleClickCell:)]) {
        [self.delegate doubleClickCell: _object];
    }
}

- (void)setObject:(HFDaoxueModel *)object
{
    _object = object;

    self.titleLabel.text = object.Dxa_Name;
    if (object.fileUrl.length > 10) {
//        NSString *imageName = [object.fileUrl substringFromIndex: object.fileUrl.length - 3];
        NSString *imageName = [[object.fileUrl componentsSeparatedByString:@"."] lastObject];
        NSArray *array = @[@"exe", @"flash", @"qita", @"music", @"excel", @"txt",@"ppt",@"pptx", @"doc",@"docx", @"mp4"];
        if ([array containsObject: imageName]) {
            self.avatarImage.image = [UIImage imageNamed: imageName];
        } else {
            self.avatarImage.image = [UIImage imageNamed: @"qita"];
        }
    } else {
    self.avatarImage.image = object.image;
    }
}

@end
