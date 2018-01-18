//
//  TestViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 19/01/2018.
//  Copyright © 2018 HengFeng. All rights reserved.
//

#import "TestViewController.h"
#import "TKImageView.h"

@interface TestViewController ()

@property (nonatomic, strong) TKImageView *tkImageView;

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUpTKImageView];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTKImageView
{
    _tkImageView = [[TKImageView alloc] initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.view addSubview: _tkImageView];
    _tkImageView.toCropImage = [UIImage imageNamed: @"guide_capture"];
    _tkImageView.showMidLines = YES;
    _tkImageView.needScaleCrop = YES;
    _tkImageView.showCrossLines = YES;
    _tkImageView.cornerBorderInImage = YES;
    _tkImageView.cropAreaCornerWidth = 44;
    _tkImageView.cropAreaCornerHeight = 44;
    _tkImageView.minSpace = 30;
    _tkImageView.cropAreaCornerLineColor = [UIColor clearColor];
    _tkImageView.cropAreaBorderLineColor = UICOLOR_RGB(0xff53baa6);
    _tkImageView.cropAreaCornerLineWidth = 6;
    _tkImageView.cropAreaBorderLineWidth = 4;
    _tkImageView.cropAreaMidLineWidth = 20;
    _tkImageView.cropAreaMidLineHeight = 6;
    _tkImageView.cropAreaMidLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineColor = [UIColor whiteColor];
    _tkImageView.cropAreaCrossLineWidth = 4;
    _tkImageView.initialScaleFactor = .8f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
