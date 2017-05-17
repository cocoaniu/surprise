//
//  VideoAlbumTableViewCell.m
//  xiuxiu
//
//  Created by edz on 2017/5/16.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "VideoAlbumTableViewCell.h"

@implementation VideoAlbumTableViewCell

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
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:[self.albumModel.coverListArray firstObject]] placeholderImage:[UIImage imageNamed:@"homePlaceholder"]];
}

@end
