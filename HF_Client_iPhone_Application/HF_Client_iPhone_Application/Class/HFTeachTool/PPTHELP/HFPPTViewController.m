//
//  HFPPTViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 19/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFPPTViewController.h"

@interface HFPPTViewController ()

@property (weak, nonatomic) IBOutlet UIButton *upButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *nextBUtton;

@end

@implementation HFPPTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"PPT助手";
    
}



- (IBAction)tpppedPptHelpAction:(UIButton *)sender
{
    switch (sender.tag) {
        case 0:
            {
                [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_LEFT_PAGE]];
            }
            break;
        case 1:
        {
            [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_CLOSE_PAGE]];
        }
            break;
        case 2:
        {
            [[HFSocketService sharedInstance] sendCtrolMessage: @[PPT_RIGHT_PAGE]];
        }
            break;
        default:
            break;
    }
}


@end
