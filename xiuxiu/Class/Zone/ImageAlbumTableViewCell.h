//
//  ImageAlbumTableViewCell.h
//  xiuxiu
//
//  Created by edz on 2017/5/12.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAlbumModel.h"

@interface ImageAlbumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thum_imageView1;

@property (weak, nonatomic) IBOutlet UIImageView *thum_imageView2;

@property (weak, nonatomic) IBOutlet UIImageView *thum_imageView3;

@property (nonatomic, strong) ImageAlbumModel *albumModel;

@end
