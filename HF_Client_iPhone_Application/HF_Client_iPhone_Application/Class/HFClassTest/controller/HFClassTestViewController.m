//
//  HFClassTestViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 08/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFClassTestViewController.h"
#import "HFClassTestDetailViewController.h"
#import "HFTeacherCaptureViewController.h"

@interface HFClassTestViewController ()

@end

@implementation HFClassTestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)classTest:(UIButton *)sender
{
    [self.navigationController pushViewController: VIEW_CONTROLLER_FROM_XIB(HFClassTestDetailViewController) animated: YES];
}

- (IBAction)capatureTest:(UIButton *)sender
{
    [self presentViewController: VIEW_CONTROLLER_FROM_XIB(HFTeacherCaptureViewController)  animated: YES completion:^{
        ;
    }];
}

@end
