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
#import "HFSocketService.h"
#import "HFCacheObject.h"
#import "XMLReader.h"
#import "HFDaoxueModel.h"
#import "HFMySourcesDetailViewController.h"

@interface HFMyResourceViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout, GCDAsyncSocketDelegate, NSXMLParserDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic)GCDAsyncSocket *socket;
@property (strong, nonatomic)NSMutableArray *studentArray;
@property (strong, nonatomic) NSMutableArray *allInfoArray;
@property (strong, nonatomic)NSString *currentElementName;
@property (strong, nonatomic)NSMutableArray *classArray;
@property (nonatomic, copy) NSString *host;
@property (nonatomic, assign) BOOL isStudent;

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
    [HFSocketService sharedInstance];
    [self loadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self loadClassData];
    });
}

- (void)loadData
{
    //    HFCacheObject *object = [HFCacheObject shardence];
    NSString *soapString = [NSString stringWithFormat: @"<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                            <soap:Header xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\" />\
                            <soap:Body>\
                            <GetDaoXueRenWuByTpID xmlns=\"http://tempuri.org/\">\
                            <tpID>%@</tpID>\
                            </GetDaoXueRenWuByTpID>\
                            </soap:Body>\
                            </soap:Envelope>", @"8926"];
    _host = [NSString stringWithFormat: @"%@%@", HOST, DAOXUEAN_INTERFACE];
    [[HFNetwork network] xmlSOAPDataWithUrl: _host soapBody: soapString success:^(id responseObject){
        [responseObject setDelegate:self];
        [responseObject parse];
        NSLog(@"我的资源请求结果成功");
    } failure:^(NSError *error) {
        NSLog(@"我的资源  请求结果失败");
        NSLog(@"loadData faild %@",error.userInfo);
    }];
}

- (void)loadClassData
{
    //    HFCacheObject *object = [HFCacheObject shardence];
    NSString *soapString = [NSString stringWithFormat: @"<soap:Envelope   xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\
                            <soap:Header xmlns:v=\"http://schemas.xmlsoap.org/soap/envelope/\" />\
                            <soap:Body>\
                            <GetCourseResByTpID xmlns=\"http://tempuri.org/\">\
                            <tpID>%@</tpID>\
                            </GetCourseResByTpID>\
                            </soap:Body>\
                            </soap:Envelope>", @"8926"];
    _host = [NSString stringWithFormat: @"%@%@", HOST, DAOXUETANG_INTERFACE];
    [[HFNetwork network] xmlSOAPDataWithUrl: _host soapBody: soapString success:^(id responseObject){
        [responseObject setDelegate:self];
        [responseObject parse];
        NSLog(@"课堂资源请求成功");
    } failure:^(NSError *error) {
    }];
}

# pragma mark - 协议方法

// 开始
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始");
}

// 获取节点头
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    self.currentElementName = elementName;
    if ([_host containsString: DAOXUEAN_INTERFACE]) {
        if ([elementName isEqualToString:@"Table1"]) {
            HFDaoxueModel *stu = [[HFDaoxueModel alloc] init];
            if (self.studentArray.count == 0) {
                [self.allInfoArray addObject: self.studentArray];
            }
            [self.studentArray addObject: stu];
        }
    } else if ([_host containsString: DAOXUETANG_INTERFACE]) {
        if ([elementName isEqualToString:@"Table1"]) {
            HFDaoxueModel *stu = [[HFDaoxueModel alloc] init];
            if (self.classArray.count == 0) {
                [self.allInfoArray addObject: self.classArray];
            }
            [self.classArray addObject: stu];
        }
    }
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([_host containsString: DAOXUEAN_INTERFACE]) {
        if (_currentElementName != nil) {
            HFDaoxueModel *stu = [self.studentArray lastObject];
            [stu setValue:string forKey:_currentElementName];
        }
        
    } else if ([_host containsString: DAOXUETANG_INTERFACE]) {
        if (_currentElementName != nil) {
            HFDaoxueModel *stu = [self.classArray lastObject];
            [stu setValue:string forKey:_currentElementName];
        }
    }
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    _currentElementName = nil;
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"结束");
    NSLog(@"导学案%zi",self.studentArray.count);
    NSLog(@"导学堂%zi",self.classArray.count);
    [self.collectionView reloadData];
}

- (void)setupLayout
{
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((SCREEN_WIDTH - 14 * 3) / 2, 80);
    self.collectionView.collectionViewLayout = layout;
}

#pragma mark - UICollectionViewDeledate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_WIDTH, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    if (section == 1) {
        return CGSizeMake(SCREEN_WIDTH, 50);
    }
    return CGSizeMake(0,FLT_MIN);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 14, 0, 14);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFMySourcesDetailViewController *vc = [[HFMySourcesDetailViewController alloc] init];
    HFMyResourceCollectionViewCell *cell = (HFMyResourceCollectionViewCell *)[self.collectionView cellForItemAtIndexPath: indexPath];
    vc.object = cell.object;
    [self.navigationController pushViewController: vc animated: YES];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFMyResourceCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    if (indexPath.section == 0 && self.studentArray.count > indexPath.row) {
        HFDaoxueModel *object = self.studentArray[indexPath.row];
        object.image = [UIImage imageNamed: @"guidance_learning"];
        cell.object = object;
    }
    if (indexPath.section == 1 && self.classArray.count > indexPath.row) {
        HFDaoxueModel *object = self.classArray[indexPath.row];
        object.image = [UIImage imageNamed: @"guidance_learning"];
        object.type = YES;
        cell.object = object;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.studentArray.count;
    } else {
        return self.classArray.count;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.allInfoArray.count;
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
        if (indexPath.section == 1) {
            headerFooterView.hidden = NO;
        } else {
            headerFooterView.hidden = YES;
        }
        headerFooterView.hidden = YES;
        reusableView = headerFooterView;
    }
    return reusableView;
}

#pragma -mark init data

- (NSMutableArray *)studentArray
{
    if (!_studentArray) {
        _studentArray = [NSMutableArray array];
    }
    return _studentArray;
}

- (NSMutableArray *)classArray
{
    if (!_classArray) {
        _classArray = [NSMutableArray array];
    }
    return _classArray;
}

- (NSMutableArray *)allInfoArray
{
    if (!_allInfoArray) {
        _allInfoArray = [NSMutableArray array];
    }
    return _allInfoArray;
}

@end
