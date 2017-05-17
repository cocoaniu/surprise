//
//  ImageDetailViewController.m
//  xiuxiu
//
//  Created by edz on 2017/5/12.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "MJPhotoBrowser.h"
#import "MBProgressHUD.h"

@import WebKit;

@interface ImageDetailViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *aS;

@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) MBProgressHUD *loadHud;

@property (nonatomic, strong) MJPhotoBrowser *photoBrowser;

@end

@implementation ImageDetailViewController

static NSString * const reuseIdentifier = @"imageCell";

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        self.dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    
    
    [self.view addSubview:self.wkWebView];
    
    self.loadHud = [MBProgressHUD showHUDAddedTo:self.collectionView animated:YES];
    
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.browseUrl]];
    
    [self.wkWebView loadRequest:request];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    
    NSString *jsString = @"function a(){\
    var arr = [];\
    var a = eval(document.getElementById('ai')).value;\
    var s = eval(document.getElementById('s')).value;\
    arr.push(a,s);\
    return arr;\
    }\
    a();";
    __weak typeof (self) weakSelf = self;
    [webView evaluateJavaScript:jsString completionHandler:^(id Result, NSError * error) {
        NSLog(@"js2__Result==%@",Result);
        if ([Result isKindOfClass:[NSArray class]]) {
            NSArray *resultArray = Result;
            weakSelf.aID = [resultArray firstObject];
            weakSelf.aS = [resultArray lastObject];
            [weakSelf showOriginalImageView];
        }
    }];
    
}



- (void)showOriginalImageView {
    
    kWeakSelf(self);
    
    NSString *url = @"http://zzz.mt27z.cn/ab/bd";
    
    NSDictionary *postDict = @{@"y":self.aID,
                               @"s":self.aS};
    
    [DQAFNetworkTool postUrlString:url body:postDict showHUD:NO showView:nil response:DQJSON bodyStyle:RequestJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.collectionView animated:YES];
        if ([[responseObject objectForKey:@"i"] isKindOfClass:[NSArray class]]) {
            for (NSDictionary *userDic in [responseObject objectForKey:@"i"]) {
                [weakSelf.dataArray addObject:[userDic objectForKey:@"url"]];
            }
            [weakSelf.collectionView reloadData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.collectionView animated:YES];
    }];

}

- (MJPhotoBrowser *)photoBrowser {
    if (!_photoBrowser) {
        _photoBrowser = [[MJPhotoBrowser alloc] init];
        NSMutableArray *urlStrArray = [NSMutableArray array];
        for (NSString *urlStr in self.dataArray) {
            MJPhoto *photo = ({
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:urlStr];
                photo.srcImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
                photo;
            });
            [urlStrArray addObject:photo];
        }
        _photoBrowser.photos = urlStrArray;
        _photoBrowser.currentPhotoIndex = 0;
    }
    return _photoBrowser;
}

- (void)showBrowserWithIndex:(NSInteger)index {
    self.photoBrowser.currentPhotoIndex = index;
    [self.photoBrowser show];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.layer.masksToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.row]] placeholderImage:[UIImage imageNamed:@"homePlaceholder"]];
    cell.backgroundView = imageView;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showBrowserWithIndex:indexPath.row];
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
