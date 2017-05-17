//
//  VideoPlayerViewController.m
//  xiuxiu
//
//  Created by edz on 2017/5/16.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "VideoPlayerViewController.h"
#import "MBProgressHUD.h"

@import WebKit;
@import AVKit;
@import AVFoundation;

@interface VideoPlayerViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *aS;

@property (nonatomic, strong) MBProgressHUD *loadHud;

@property (nonatomic, copy) NSString *videoURL;

@end

@implementation VideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wkWebView = [[WKWebView alloc] initWithFrame:CGRectZero];
    self.wkWebView.navigationDelegate = self;
    self.wkWebView.UIDelegate = self;
    
    
    [self.view addSubview:self.wkWebView];
    
    self.loadHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
            [weakSelf showOriginalVideoView];
        }
    }];
    
}

- (void)showOriginalVideoView {
    kWeakSelf(self);
    
    NSString *url = @"http://zzz.mt27z.cn/ab/bd";
    
    NSDictionary *postDict = @{@"y":self.aID,
                               @"s":self.aS};
    
    [DQAFNetworkTool postUrlString:url body:postDict showHUD:NO showView:nil response:DQJSON bodyStyle:RequestJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
        weakSelf.videoURL = [responseObject objectForKey:@"v"];
    
        self.player = [AVPlayer playerWithURL:[NSURL URLWithString:weakSelf.videoURL]];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
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
