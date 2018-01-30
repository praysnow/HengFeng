//
//  HFFileUploadViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2018/1/16.
//  Copyright © 2018年 HengFeng. All rights reserved.
//

#import "HFFileUploadViewController.h"
#import "SCRFTPRequest.h"

@interface HFFileUploadViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,SCRFTPRequestDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic)  UIImagePickerController *imagePickerVC; // 相片选择控制器

@property (strong, nonatomic)  NSString *filePath;

@property (strong, nonatomic)  SCRFTPRequest *ftpRequest;

@end

@implementation HFFileUploadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"文件上传";
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"选择图片" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(imagePicker) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    // 弹出选择图片
    [self imagePicker];
}

- (void)imagePicker{
    NSLog(@"图片选择");
//    [self presentViewController:self.imagePickerVC animated:YES completion:nil];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:self.imagePickerVC animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        self.imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.imagePickerVC animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)startUpload:(id)sender {
    NSLog(@"上屏");
    
    if(self.imageView.image == nil){
        [self showText:@"请选择一张图片"];
        return;
    }
    
    
    [self handleImage:self.imageView.image];
}

- (IBAction)stopUpload:(id)sender {
    NSLog(@"停止上屏");
    [[HFSocketService sharedInstance] sendCtrolMessage: @[STOP_UP_SCREEN ]];
}

- (void)handleImage:(UIImage *)image{
    
    _filePath = [NSString stringWithFormat:@"%@%@",[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/portraitPic"],@"iOS.jpg"];
    
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/portraitPic"] isDirectory:&isDir] || isDir == NO) {
        
        [fileManager createDirectoryAtPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/portraitPic"] withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // 存储到沙盒 压缩0.25
    NSData *data = UIImageJPEGRepresentation(image, 0.25);
    [fileManager createFileAtPath:_filePath contents:data attributes:nil];
    
    // 上传到ftp
    NSString *urlString = [NSString stringWithFormat:@"ftp://%@/root/mobileshow/",[HFNetwork network].SocketAddress];
    ;
    _ftpRequest = [[SCRFTPRequest alloc] initWithURL:[NSURL URLWithString:urlString] toUploadFile:_filePath];
    

    
    _ftpRequest.delegate = self;
    
    [_ftpRequest startRequest];
    
}

#pragma mark - SCRFTPRequestDelegate
- (void)ftpRequestDidFinish:(SCRFTPRequest *)request{
    NSLog(@"上传成功");
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showText:@"上传成功"];
    // 删掉本地图片
    
    
    
    // 发送指令
    NSString *filePath = [NSString stringWithFormat:@"/root/mobileshow/portraitPiciOS.jpg"]; 
    
    NSLog(@"ftp路径%@",filePath);
    [[HFSocketService sharedInstance] sendCtrolMessage: @[UP_SCREEN,filePath]];
    
    
}

- (void)ftpRequest:(SCRFTPRequest *)request didFailWithError:(NSError *)error{
    
    NSLog(@"上传失败");
    [self showText:@"上传失败"];
    // 删掉本地图片
}

- (void)ftpRequestWillStart:(SCRFTPRequest *)request{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}



#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
    self.imageView.image = info[UIImagePickerControllerOriginalImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.imagePickerVC dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImagePickerController *)imagePickerVC{
    if (_imagePickerVC == nil) {
        _imagePickerVC = [[UIImagePickerController alloc] init];
        // 只选择本地图片
//        _imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerVC.delegate = self;
        _imagePickerVC.allowsEditing = YES;
    }
    
    return _imagePickerVC;
}



@end
