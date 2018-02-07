//
//  HFToolVoteViewController.m
//  HF_Client_iPhone_Application
//
//  Created by Caesar on 14/12/2017.
//  Copyright © 2017 HengFeng. All rights reserved.
//

#import "HFToolVoteViewController.h"
#import "HFVoteTableViewCell.h"
#import "HFNetwork.h"

#define OPTION_ARRAY [HFCacheObject shardence].optionArray

@interface HFToolVoteViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *selectVoteButton;
@property (weak, nonatomic) IBOutlet UIButton *jianButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *questionNumLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *commitLabel;
@property (weak, nonatomic) IBOutlet UILabel *uncommitLabel;

@end

@implementation HFToolVoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = @"教学工具-投票";
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(startVoting) name: @"startVoting" object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reloadVoteMessage) name: @"SendFormatQuestion" object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reloadVoteMessage) name: @"SendSelectToCtrl" object: nil];
    [self initUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[STOP_VOTE_STATUE]];
    [[HFCacheObject shardence].optionArray removeAllObjects];
    [HFCacheObject shardence].commitCount = 0;
}

- (void)initUI{
    [self.tableView registerNib: [UINib nibWithNibName: NSStringFromClass([HFVoteTableViewCell class]) bundle: nil] forCellReuseIdentifier: @"Cell"];
}

#pragma mark - NSNotificationCenter method

- (void)reloadVoteMessage
{
    self.commitLabel.text = [NSString stringWithFormat: @"已提交：%zi人", [HFCacheObject shardence].commitCount];
//    NSInteger count = [HFNetwork network].studentArray.count;
//    self.uncommitLabel.text = [NSString stringWithFormat: @"未提交：%zi人", count - (NSInteger)[HFCacheObject shardence].commitCount];
//                               [HFNetwork network].studentArray.count - [HFCacheObject shardence].commitCount];

    self.coverImageView.hidden = YES;
    [self.tableView reloadData];
}

- (void)startVoting
{
    
}

#pragma mark - UITableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HFVoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    cell.object = OPTION_ARRAY[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return OPTION_ARRAY.count;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    
    self.coverImageView.hidden = NO;
    [[HFSocketService sharedInstance] sendCtrolMessage: @[RECOMMEND_VOTE]];
}

- (IBAction)selectVote:(id)sender {
    NSLog(@"单选题");
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[SINGLE_OR_DOUBLE_CHANGLE]];
    
    if([_selectVoteButton.titleLabel.text isEqualToString:@"单选题"]){
        [_selectVoteButton setTitle:@"多选题" forState:UIControlStateNormal];
        [_selectVoteButton setImage:[UIImage imageNamed:@"多选"] forState:UIControlStateNormal];
        
        
        _questionNumLabel.text = @"4";
        _jianButton.imageView.image = [UIImage imageNamed:@"_1"];
        
    }else{
        [_selectVoteButton setTitle:@"单选题" forState:UIControlStateNormal];
        [_selectVoteButton setImage:[UIImage imageNamed:@"单选"] forState:UIControlStateNormal];
        
        _questionNumLabel.text = @"2";
        _jianButton.imageView.image = [UIImage imageNamed:@"_1"];
    }
}

- (IBAction)jianButton:(id)sender {
    NSLog(@"减法");
    
    NSInteger num = [_questionNumLabel.text integerValue];
    if([_selectVoteButton.titleLabel.text isEqualToString:@"单选题"] && num == 2){
        return;
    }
    
    if([_selectVoteButton.titleLabel.text isEqualToString:@"多选题"] && num == 4){
        return;
    }
    
    
    [_addButton setImage:[UIImage imageNamed:@"+"] forState:UIControlStateNormal];
    
    
    num--;
    _questionNumLabel.text = [NSString stringWithFormat:@"%zd",num];
    
    if([_selectVoteButton.titleLabel.text isEqualToString:@"单选题"]){
        if(num == 2){
            [_jianButton setImage:[UIImage imageNamed:@"_1"] forState:UIControlStateNormal];
        }
    }
    
    if([_selectVoteButton.titleLabel.text isEqualToString:@"多选题"]){
        if(num == 4){
            [_jianButton setImage:[UIImage imageNamed:@"_1"] forState:UIControlStateNormal];
        }
    }
    
}

- (IBAction)addButton:(id)sender {
    NSLog(@"加法");
    
    NSInteger num = [_questionNumLabel.text integerValue];
    
    if(num == 12){
        return;
    }
    
    [_jianButton setImage:[UIImage imageNamed:@"_"] forState:UIControlStateNormal];
    
    num++;
    _questionNumLabel.text = [NSString stringWithFormat:@"%zd",num];
    
    if(num == 12){
        [_addButton setImage:[UIImage imageNamed:@"+1-1"] forState:UIControlStateNormal];
    }
}

- (IBAction)beginVote:(id)sender {
    NSLog(@"开始投票");
    
    NSInteger num = [_questionNumLabel.text integerValue];
    [[HFSocketService sharedInstance] sendCtrolMessage: @[START_OR_RESTART_VOTE,@(num)]];
    self.coverImageView.hidden = YES;
}

- (IBAction)endVote:(id)sender {
    NSLog(@"结束投票");
    
    [[HFSocketService sharedInstance] sendCtrolMessage: @[STOP_VOTE_STATUE]];
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImageView *)coverImageView
{
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"尚未投票"]];
        _coverImageView.contentMode = UIViewContentModeCenter;
        _coverImageView.backgroundColor = [UIColor whiteColor];
        _coverImageView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 60);
        [self.view addSubview: _coverImageView];
        _coverImageView.hidden = YES;
    }
    return _coverImageView;
}

@end
