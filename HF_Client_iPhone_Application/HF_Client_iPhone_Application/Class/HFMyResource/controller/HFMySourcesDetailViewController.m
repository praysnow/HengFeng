//
//  HFMySourcesDetailViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 14/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFMySourcesDetailViewController.h"

@interface HFMySourcesDetailViewController ()

@end

@implementation HFMySourcesDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = _object.type ? _object.resName : _object.Dxa_Name;
    [self showBackButton];
}
@end
