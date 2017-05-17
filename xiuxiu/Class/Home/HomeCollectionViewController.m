//
//  HomeCollectionViewController.m
//  xiuxiu
//
//  Created by edz on 2017/5/12.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "HomeCollectionViewController.h"
#import "AuthorModel.h"
#import "HomeCollectionViewCell.h"
#import "UserViewController.h"

@interface HomeCollectionViewController ()

@property (nonatomic, strong) NSMutableArray <AuthorModel *>*dataArray;

@property (nonatomic, copy) NSString *tailID;

@property (nonatomic, assign) BOOL isEnd;

@end

@implementation HomeCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Register cell classes
    
    // Do any additional setup after loading the view.
    
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
    
    NSString *url = @"https://meituzz.com/showmay/discover";
    
    NSDictionary *postDict = @{@"count":@"10",
                               @"isIOS":@"0",
                               @"tailID":self.tailID,
                               @"userID":@"145053",
                               @"userKey":@"ZB4g2uG-UQVRQNHkBvJV-95Oj0zpZQqN"
                               };
    [DQAFNetworkTool postUrlString:url body:postDict showHUD:YES showView:self.collectionView response:DQJSON bodyStyle:RequestJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSLog(@"=====%@=======asdaosdasd",responseObject);
        weakSelf.isEnd = [[responseObject objectForKey:@"isEnd"] boolValue];
        
        if ([weakSelf.tailID isEqualToString:@"0"]) {
            [weakSelf.dataArray removeAllObjects];
        }
        
        if ([[responseObject objectForKey:@"discoverList"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *userDic in [responseObject objectForKey:@"discoverList"]) {
                AuthorModel *model = [[AuthorModel alloc] init];
                [model setValuesForKeysWithDictionary:userDic];
                [weakSelf.dataArray addObject:model];
            }
            weakSelf.tailID = [weakSelf.dataArray lastObject].ID;
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - 刷新加载
- (void)addHeader
{
    __weak typeof(self) vc = self;
    // 添加下拉刷新头部控件
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 进入刷新状态后会自动调用这个block
        vc.tailID = @"0";
        vc.isEnd = NO;
        [vc p_solveData:vc.tailID];
        // 结束刷新
        [vc.collectionView.mj_footer resetNoMoreData];
        [vc.collectionView.mj_header endRefreshing];
    }];
    
    // 马上进入刷新状态
    [self.collectionView.mj_header beginRefreshing];
}


- (void)addFooter
{
    __weak typeof(self) vc = self;
    
    // 添加上拉刷新尾部控件
    self.collectionView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        if (vc.isEnd) {
            [vc.collectionView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [vc p_solveData:vc.tailID];
            [vc.collectionView reloadData];
            // 结束刷新
            [vc.collectionView.mj_footer endRefreshing];
        }
    }];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"imageUserPush"]) {
        UserViewController *albumVC = segue.destinationViewController;
        HomeCollectionViewCell *cell = sender;
        albumVC.modelID = cell.authorModel.ID;
    }
    
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    cell.authorModel = self.dataArray[indexPath.row];
    
    return cell;
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    ImageAlbumTableViewController *albumVC = [[ImageAlbumTableViewController alloc] init];
//    albumVC.modelID = self.dataArray[indexPath.row].ID;
//}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
