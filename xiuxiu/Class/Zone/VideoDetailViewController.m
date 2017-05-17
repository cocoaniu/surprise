//
//  VideoDetailViewController.m
//  xiuxiu
//
//  Created by edz on 2017/5/16.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "MBProgressHUD.h"

@import WebKit;
@import AVFoundation;
@import AVKit;

@interface VideoDetailViewController ()<WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, copy) NSString *aID;
@property (nonatomic, copy) NSString *aS;

@property (nonatomic, strong) MBProgressHUD *loadHud;

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerViewController  *playerView;

@property (nonatomic, copy) NSString *videoURL;

@end

@implementation VideoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
        [weakSelf createVideoView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
    }];
}

- (void)createVideoView {
    //视频播放的url
    NSURL *playerURL = [NSURL URLWithString:self.videoURL];
    
    //初始化
    self.playerView = [[AVPlayerViewController alloc]init];
    
    //AVPlayerItem 视频的一些信息  创建AVPlayer使用的
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:playerURL];
    
    //通过AVPlayerItem创建AVPlayer
    self.player = [[AVPlayer alloc]initWithPlayerItem:item];
    
    //给AVPlayer一个播放的layer层
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    layer.frame = CGRectMake(0, 100, self.view.frame.size.width, 200);
    
    layer.backgroundColor = [UIColor greenColor].CGColor;
    
    //设置AVPlayer的填充模式
    layer.videoGravity = AVLayerVideoGravityResize;
    
    [self.view.layer addSublayer:layer];
    
    //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
    self.playerView.player = self.player;
    
    //关闭AVPlayerViewController内部的约束
    self.playerView.view.translatesAutoresizingMaskIntoConstraints = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self showViewController:self.playerView sender:nil];
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
