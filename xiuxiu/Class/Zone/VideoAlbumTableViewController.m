//
//  VideoAlbumTableViewController.m
//  xiuxiu
//
//  Created by edz on 2017/5/16.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "VideoAlbumTableViewController.h"
#import "ImageAlbumModel.h"
#import "VideoAlbumTableViewCell.h"
#import "VideoDetailViewController.h"
#import "VideoPlayerViewController.h"

@interface VideoAlbumTableViewController ()

@property (nonatomic, strong) NSMutableArray <ImageAlbumModel *>*dataArray;

@property (nonatomic, copy) NSString *maxTime;

@property (nonatomic, assign) BOOL isEnd;


@end

@implementation VideoAlbumTableViewController

static NSString * const reuseIdentifier = @"videoCell";

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    [self addHeader];
    [self addFooter];
    
}


#pragma mark - 数据解析
- (void)p_solveData:(NSString *)tailID
{
    kWeakSelf(self);
    
    NSString *url = @"https://meituzz.com/model/album-list";
    
    NSDictionary *postDict = @{@"count":@"10",
                               @"maxTime":self.maxTime,
                               @"modelID":self.modelID,
                               @"type":@"videoAlbum",
                               @"userID":USER_ID,
                               @"userKey":USER_KEY
                               };
    [DQAFNetworkTool postUrlString:url body:postDict showHUD:YES showView:self.tableView response:DQJSON bodyStyle:RequestJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        weakSelf.isEnd = [[responseObject objectForKey:@"isEnd"] boolValue];
        
        if ([weakSelf.maxTime isEqualToString:@"0"]) {
            [weakSelf.dataArray removeAllObjects];
        }
        
        if ([[responseObject objectForKey:@"albumList"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *userDic in [responseObject objectForKey:@"albumList"]) {
                ImageAlbumModel *model = [[ImageAlbumModel alloc] init];
                [model setValuesForKeysWithDictionary:userDic];
                [weakSelf.dataArray addObject:model];
            }
            weakSelf.maxTime = [NSString stringWithFormat:@"%@",[weakSelf.dataArray lastObject].postTime];
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 刷新加载
- (void)addHeader
{
    __weak typeof(self) vc = self;
    // 添加下拉刷新头部控件
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        vc.maxTime = @"0";
        vc.isEnd = NO;
        [vc p_solveData:vc.maxTime];
        // 结束刷新
        [vc.tableView.mj_footer resetNoMoreData];
        [vc.tableView.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
}


- (void)addFooter
{
    __weak typeof(self) vc = self;
    
    // 添加上拉刷新尾部控件
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (vc.isEnd) {
            [vc.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [vc p_solveData:vc.maxTime];
            [vc.tableView reloadData];
            // 结束刷新
            [vc.tableView.mj_footer endRefreshing];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoAlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.albumModel = self.dataArray[indexPath.row];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
//    if ([segue.identifier isEqualToString:@"imageDetaillPush"]) {
//        VideoDetailViewController *albumVC = segue.destinationViewController;
//        VideoAlbumTableViewCell *cell = sender;
//        albumVC.browseUrl = cell.albumModel.browseUrl;
//    }
    
    if ([segue.identifier isEqualToString:@"imageDetaillModal"]) {
        VideoPlayerViewController *albumVC = segue.destinationViewController;
        VideoAlbumTableViewCell *cell = sender;
        albumVC.browseUrl = cell.albumModel.browseUrl;
    }
    
}


@end
