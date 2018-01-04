//
//  HFStudentStatusPersonViewController.m
//  HF_Client_iPhone_Application
//
//  Created by 陈炳桦 on 2017/12/20.
//  Copyright © 2017年 HengFeng. All rights reserved.
//

#import "HFStudentStatusPersonViewController.h"
#import "HFTTeachToolCollectionViewCell.h"
#import "HFNetwork.h"
#import "WebServiceModel.h"
#import "HFStudentModel.h"

@interface HFStudentStatusPersonViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,  UICollectionViewDelegateFlowLayout,NSXMLParserDelegate>

@property (strong, nonatomic)NSString *currentElementName;
@property (strong, nonatomic)NSMutableArray *studentArray; // 学生数组

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation HFStudentStatusPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"学生状态-个人";
    
    [self GetStudentListByClassID]; // 请求数据
    
    [self setupUI];
}

- (void)setupUI{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib: [UINib nibWithNibName: NSStringFromClass([HFTTeachToolCollectionViewCell class]) bundle: nil] forCellWithReuseIdentifier: @"Cell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(FLEXIBLE_WIDTH(60), 40); self.collectionView.collectionViewLayout = layout;
}

- (void)GetStudentListByClassID{
    WebServiceModel *model = [WebServiceModel new];
    model.method = @"GetStudentListByClassID";
    
    NSString *classId = [HFCacheObject shardence].classId;
    
    if (classId == nil) {
        NSLog(@"%@",@"classId为空");
        return;
        
    }
    if (classId.length != 0) {
        model.params = @{@"ClassID":classId}.mutableCopy;
    }
    
    NSString *url = [NSString stringWithFormat: @"%@%@", HOST, @"webService/WisdomClassWS.asmx"];
    [[HFNetwork network] xmlSOAPDataWithUrl:url soapBody:[model getRequestParams] success:^(id responseObject) {
        
        
        [responseObject setDelegate:self];
        [responseObject parse];
        NSLog(@"获取学生列表成功");
        
    } failure:^(NSError *error) {
        
    }];
}

# pragma mark - NSXMLParserDelegate
// 开始
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    NSLog(@"开始");
}

// 获取节点头
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict {
    self.currentElementName = elementName;

    
    if ([elementName isEqualToString:@"Table1"]) {
        // 创建学生模型
        HFStudentModel *stu = [HFStudentModel new];
        [self.studentArray addObject:stu];
        
    }
    
}

// 获取节点的值 (这个方法在获取到节点头和节点尾后，会分别调用一次)
- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {

    HFStudentModel *stu = [self.studentArray lastObject];
    [stu setValue:string forKey:_currentElementName];
}

// 获取节点尾
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    _currentElementName = nil;
}

// 结束
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"结束");
    NSLog(@"导学案%zi",self.studentArray.count);
    NSLog(@"%@",self.studentArray);
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout :(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选择");
    // 设置为单选
    HFTTeachToolCollectionViewCell *cell;
    for(int i = 0 ; i < self.studentArray.count;i++){
        cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: [NSIndexPath indexPathForRow:i inSection:0]];
        if (cell != nil) {
            [cell setSelected:NO];
        }
        
    }
    cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    [cell setSelected:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.studentArray.count;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HFTTeachToolCollectionViewCell *cell =  [collectionView dequeueReusableCellWithReuseIdentifier: @"Cell" forIndexPath: indexPath];
    cell.studentModel = self.studentArray[indexPath.row];
    return cell;
}



#pragma -mark 懒加载
- (NSMutableArray *)studentArray
{
    if (!_studentArray) {
        _studentArray = [NSMutableArray array];
    }
    return _studentArray;
}

- (IBAction)add1:(id)sender {
    NSLog(@"+1");
}
- (IBAction)add2:(id)sender {
    NSLog(@"+2");
}
- (IBAction)add3:(id)sender {
    NSLog(@"+3");
}
- (IBAction)Ranking:(id)sender {
    NSLog(@"排行");
}

@end
