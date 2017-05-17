//
//  ImageAlbumTableViewCell.m
//  xiuxiu
//
//  Created by edz on 2017/5/12.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "ImageAlbumTableViewCell.h"

@implementation ImageAlbumTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAlbumModel:(ImageAlbumModel *)albumModel {
    _albumModel = albumModel;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.albumModel.avatar] placeholderImage:[UIImage imageNamed:@"homePlaceholder"]];
    self.nameLabel.text = self.albumModel.nickname;
    self.titleLabel.text = self.albumModel.title;
    for (int i = 100; i < 103; i++) {
        UIImageView *imageView = [self viewWithTag:i];
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.albumModel.coverListArray[i - 100]] placeholderImage:[UIImage imageNamed:@"homePlaceholder"]];
    }
}



@end
