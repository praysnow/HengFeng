//
//  HFMyResourceViewController.m
//  HF_Client_iPhone_Application
//
//  Created by liuyang on 2017/11/10.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFMyResourceViewController.h"
#import "HFMyResourceCollectionViewCell.h"
#import "HFMyResourceHeaderFootView.h"
#import "HFNetwork.h"
#import "WebServiceModel.h"

@interface HFMyResourceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, GCDAsyncSocketDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)GCDAsyncSocket *socket;

@end

@implementation HFMyResourceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFMyResourceCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];
    [self.collectionView registerNib: [UINib nibWithNibName: @"HFMyResourceHeaderFootView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    [self.collectionView registerNib: [UINib nibWithNibName: @"HFMyResourceHeaderFootView" bundle: nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    [self setupLayout];
    [self getClassInfo];
    //    [self loadData];
}

- (void)getClassInfo
{
    [self connectServer: @"192.168.15.29" port: 1001];
}

- (int)connectServer:(NSString *)hostIP port:(int)hostPort
{
    if (_socket == nil) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
        [_socket readDataWithTimeout: -1 tag: 0];
        NSError *err = nil;
        int t = [_socket connectToHost:hostIP onPort:hostPort error:&err];
        if (!t) {
            return 0;
        }else{
            return 1;
        }
    }else {
        [_socket readDataWithTimeout:-1 tag:0];
        return 1;
    }
}

// 连接成功
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    BOOL state = [self.socket isConnected];
    if (state) {
        NSLog(@"socket 已连接");
        [self sendCmd];
    }else{
        NSLog(@"socket 没有连接");
    }
    [self.socket readDataWithTimeout:-1 tag:0];//WithTimeout 是超时时间,-1表示一直读取数据
}

// 发送命令
- (void)sendCmd{
    int length = (int)1;
    int steamId = (int)1;
    
    Byte type = (Byte)(0x99);
    length = (length);
    steamId = (steamId);
    Byte body = (Byte)(0x99);
    //    Byte type = (Byte)(0x99);
    //    Byte body = (Byte)(0x99);
    NSData *typeData = [NSData dataWithBytes: &type length: 1];
    NSData *lengthData = [NSData dataWithBytes:&length length: sizeof(length)];
    NSData *steamIdData = [NSData dataWithBytes:&steamId length: sizeof(steamId)];
    NSData *bodyData = [NSData dataWithBytes: &body length: 1];
    NSMutableData *mutableData = [NSMutableData new];
    [mutableData appendData: typeData];
    [mutableData appendData: lengthData];
    [mutableData appendData: steamIdData];
    [mutableData appendData: bodyData];
    NSLog(@"send message : %@ %@ steam: %@ body:%@", typeData, lengthData , steamIdData, bodyData);
    NSLog(@"心跳包: %@", mutableData);
    [self.socket writeData: mutableData withTimeout:-1 tag:0];
}

- (Byte)transByteFormint:(int)value
{
    char *p_time = (char *)&value;
    char str_time[4] = {0};
    for(int i= 0 ;i < 4 ;i++)
    {
        str_time[i] = *p_time;
        p_time ++;
    }
    return *p_time;
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataWithTimeout: -1 tag: tag];
}

// 读取数据
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSString* aStr = (NSString *)[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"iOS 接收命令:%zd  %@",data.length,aStr);
}

- (void)sendLoginInfo
{
//     NSString *loginStatus = @"Login?name=TeacherCtrl&os=android&class=defaultEx";
    NSString *loginStatus = @"<?xml version=\"1.0\" encoding=\"utf-16\"?>\
    <XmlPkHeader xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" From=\"TeacherCtrl\" To=\"=\" CommandCode=\"CtrlCmd\" Channel=\"\" PKID=\"e1963ff6-0c5e-4ad1-a523-4b9dadf50b19\" />{7A76F682-6058-4EBC-A5AF-013A4369EE0E}111";
    NSData *data = [loginStatus dataUsingEncoding:NSUTF8StringEncoding];
    
    int length = (int)data.length;
    int steamId = (int)0;
    
    Byte type = (Byte)(0x00);
    NSData *typeData = [NSData dataWithBytes: &type length: 1];
    NSData *lengthData = [NSData dataWithBytes:&length length: sizeof(length)];
    NSData *steamIdData = [NSData dataWithBytes:&steamId length: sizeof(steamId)];
    NSMutableData *mutableData = [NSMutableData new];
    [mutableData appendData: typeData];
    [mutableData appendData: lengthData];
    [mutableData appendData: steamIdData];
    [mutableData appendData: data];
    NSLog(@"发送登录状态");
    [self.socket writeData: mutableData withTimeout: -1 tag: 0];
}

// 断开连接
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    BOOL state = [_socket isConnected];   // 判断当前socket的连接状态
    NSLog(@"连接状态: %d",state);
    self.socket=nil;
}

- (void)loadData
{
    WebServiceModel *model = [[WebServiceModel alloc] init];
    model.method = @"GetDaoXueRenWuByTpID";
    [[HFNetwork network] SOAPDataWithSoapBody: [model getRequestParams] success:^(id responseObject) {
        NSLog(@"我的资源  请求结果为%@", responseObject);
    } failure:^(NSError *error) {
        NSLog(@"我的资源  请求结果失败");
        NSLog(@"loadData faild %@",error.userInfo);
    }];
}

- (void)setupLayout
{
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(FLEXIBLE_WIDTH(100), 100);
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - UICollectionViewDeledate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
    return CGSizeMake(0,0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 100;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
    return CGSizeMake(0,10);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 14, 0, 14);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    [self getClassInfo];
    [self sendLoginInfo];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFMyResourceCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 4;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    HFMyResourceHeaderFootView *reusableView = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        HFMyResourceHeaderFootView *headerFooterView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionHeader withReuseIdentifier: @"HeaderView" forIndexPath: indexPath];
        //        headerFooterView.delegate = self;
        reusableView = headerFooterView;
    }
    reusableView.backgroundColor = [UIColor whiteColor];
    if (kind == UICollectionElementKindSectionFooter)
    {
        HFMyResourceHeaderFootView *headerFooterView = [collectionView dequeueReusableSupplementaryViewOfKind: UICollectionElementKindSectionFooter withReuseIdentifier: @"FooterView" forIndexPath: indexPath];
        if (indexPath.section == 3) {
            headerFooterView.hidden = NO;
        } else {
            headerFooterView.hidden = YES;
        }
        reusableView = headerFooterView;
    }
    return reusableView;
}

@end
