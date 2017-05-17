//
//  UserViewController.h
//  xiuxiu
//
//  Created by edz on 2017/5/16.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController

@property (nonatomic, copy) NSString *modelID;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;

@property (weak, nonatomic) IBOutlet UILabel *imageAlbumLabel;

@property (weak, nonatomic) IBOutlet UILabel *videoAlbumLabel;

@end
