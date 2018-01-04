//
//  HFUserInfoViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 02/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "HFUserInfoViewController.h"
#import "HFUserInfocellTableViewCell.h"

@interface HFUserInfoViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;

@end

@implementation HFUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([HFUserInfocellTableViewCell class]) bundle: nil] forCellReuseIdentifier: @"cell"];
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.layer.cornerRadius = self.avatarImage.width / 2;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"cell"];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

@end
