//
//  HFTeachShareViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 25/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFTeachShareViewController.h"

@interface HFTeachShareViewController ()

@end

@implementation HFTeachShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"教学分享";
}

- (IBAction)tappedTeachShare:(UIButton *)sender
{
    sender.selected = !sender.selected;

    [sender setTitle: @"开始教学分享" forState: UIControlStateDisabled];
    [sender setTitle: @"停止教学分享" forState: UIControlStateSelected];
    [[HFSocketService sharedInstance] sendCtrolMessage: @[sender.selected ? END_TESCHER_SHARE : START_TESCH_SHARE]];
}

@end
