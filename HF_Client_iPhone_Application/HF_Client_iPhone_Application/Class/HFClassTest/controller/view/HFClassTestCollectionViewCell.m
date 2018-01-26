//
//  HFClassTestCollectionViewCell.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 23/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFClassTestCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface HFClassTestCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UILabel *hf_titleLabel;

@end

@implementation HFClassTestCollectionViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.borderColor = UICOLOR_ARGB(0xffe0e0e0).CGColor;
    self.contentView.layer.borderWidth = 2.0f;
    UITapGestureRecognizer *doubleTabGesture=[[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(handleDoubleTap:)];
    [doubleTabGesture setNumberOfTapsRequired:2];
    [self addGestureRecognizer: doubleTabGesture];
}

- (void)setObject:(HFClassTestObject *)object
{
    self.hf_titleLabel.text = object.Name;
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat: @"%@%@", [HFNetwork network].SocketAddress, object.fileName]];
    [self.imageView sd_setImageWithURL: url];
    _object = object;
}

- (void)handleDoubleTap: (UITapGestureRecognizer *)gesture
{
    if ([self.delegate respondsToSelector: @selector(doubleClickCell:)]) {
        [self.delegate doubleClickCell: _object];
    }
}

@end
