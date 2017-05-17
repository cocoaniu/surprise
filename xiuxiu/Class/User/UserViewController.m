//
//  UserViewController.m
//  xiuxiu
//
//  Created by edz on 2017/5/16.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "UserViewController.h"
#import "UserModel.h"
#import "ImageAlbumTableViewController.h"
#import "VideoAlbumTableViewController.h"

@interface UserViewController ()

@property (nonatomic, strong) UserModel *userModel;

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationController.navigationBar.translucent = NO;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
    backItem.title = @"返回";
    self.navigationItem.backBarButtonItem = backItem;
    
    kWeakSelf(self);

    NSString *url = @"https://meituzz.com/model/overview";
    
    NSDictionary *postDict = @{@"modelID":self.modelID,
                               @"userID":USER_ID,
                               @"userKey":USER_KEY
                               };
    [DQAFNetworkTool postUrlString:url body:postDict showHUD:YES showView:self.view response:DQJSON bodyStyle:RequestJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSLog(@"%@",responseObject);
        
        weakSelf.userModel = [[UserModel alloc] init];
        [weakSelf.userModel setValuesForKeysWithDictionary:responseObject];

        weakSelf.nameLabel.text = weakSelf.userModel.nickname;
        [weakSelf.avatarImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.userModel.avatar] placeholderImage:[UIImage imageNamed:@"homePlaceholder"]];
        [weakSelf.coverImageView sd_setImageWithURL:[NSURL URLWithString:weakSelf.userModel.coverUrl] placeholderImage:[UIImage imageNamed:@"homePlaceholder"]];
        weakSelf.imageAlbumLabel.text = [NSString stringWithFormat:@"%@个相册",weakSelf.userModel.albumCount];
        weakSelf.videoAlbumLabel.text = [NSString stringWithFormat:@"%@个影集",weakSelf.userModel.videoCount];
        
        weakSelf.title = weakSelf.userModel.nickname;
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
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
    if ([segue.identifier isEqualToString:@"imageAlbumPush"]) {
        ImageAlbumTableViewController *albumVC = segue.destinationViewController;
        albumVC.modelID = self.modelID;
    } else if ([segue.identifier isEqualToString:@"videoAlbumPush"]) {
        VideoAlbumTableViewController *albumVC = segue.destinationViewController;
        albumVC.modelID = self.modelID;
    }
}


@end
