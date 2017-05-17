//
//  VideoAlbumTableViewCell.h
//  xiuxiu
//
//  Created by edz on 2017/5/16.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageAlbumModel.h"

@interface VideoAlbumTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (nonatomic, strong) ImageAlbumModel *albumModel;

@end
