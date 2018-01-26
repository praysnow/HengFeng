//
//  ZSSelectView.m
//  BaibuSeller
//
//  Created by 陈炳桦 on 16/11/24.
//  Copyright © 2016年 whawhawhat. All rights reserved.
//

#import "ZSSelectView.h"
#import "ZSSelectViewCell.h"

static NSString *ID = @"ID";

@interface ZSSelectView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableViewController *tableViewVC;

@end

@implementation ZSSelectView



+ (instancetype)selectViewWithTitle:(NSString *)title andContentArray:(NSArray *)contentArray andResultBlock:(ResultBlock) resultBlock{
    ZSSelectView *selectView = [[ZSSelectView alloc] init];
    
    selectView.contentArray = contentArray;
    selectView.resultBlock = resultBlock;
    
    
    return selectView;
    
}

#pragma mark - 初始化
- (instancetype)init{
    if(self = [super init])
    {
        
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.windowLevel = UIWindowLevelAlert;
        [self setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
        
        self.rootViewController = self.tableViewVC;
        self.hidden = YES;
    }
    return self;
}

- (void)tap{
    self.hidden = YES;
    [self resignKeyWindow];
}

#pragma mark - 懒加载
- (UITableViewController *)tableViewVC{
    if (_tableViewVC == nil) {
        _tableViewVC = [[UITableViewController alloc] init];
        _tableViewVC.tableView.delegate = self;
        _tableViewVC.tableView.dataSource = self;
//        _tableViewVC.tableView.separatorStyle = NO; // 取消分割线
       
        _tableViewVC.tableView.layer.cornerRadius = 10;
        _tableViewVC.tableView.layer.masksToBounds = YES;
        _tableViewVC.tableView.layer.borderWidth = 1;
        _tableViewVC.tableView.layer.borderColor = [UIColor grayColor].CGColor;
        
        // 注册ZSSelectViewCell
        [_tableViewVC.tableView registerNib:[UINib nibWithNibName:@"ZSSelectViewCell" bundle:nil] forCellReuseIdentifier:ID];
        
    }
    
    return _tableViewVC;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat viewW = SCREEN_WIDTH / 4;
    CGFloat viewH = _contentArray.count * 50;
    
    self.tableViewVC.tableView.frame = CGRectMake(_point.x, _point.y, viewW, viewH);
    [self addSubview:self.tableViewVC.tableView];
    
    
}

- (void)show{
    [self makeKeyAndVisible];
    self.hidden = NO;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    
    UIView *fitView = [super hitTest:point withEvent:event];
    
    if (fitView != self) {
        
    }else{
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
    }
    
    return fitView;
}

#pragma mark - UITableViewDataSource
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *redView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
//    redView.backgroundColor = [UIColor redColor];
//
//    return redView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 50;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ZSSelectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    cell.nameLabel.text = _contentArray[indexPath.row];
    
//    cell.textLabel.textColor = [UIColor blackColor];
//    cell.textLabel.text = _contentArray[indexPath.row];
//    cell.textLabel.font = [UIFont systemFontOfSize:10];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_resultBlock) {
        _resultBlock(indexPath.row,_contentArray[indexPath.row]);
    }
    
    self.hidden = YES;
    [self resignKeyWindow];
}


@end
