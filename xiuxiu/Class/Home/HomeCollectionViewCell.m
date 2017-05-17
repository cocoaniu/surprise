//
//  HomeCollectionViewCell.m
//  xiuxiu
//
//  Created by edz on 2017/5/12.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell

- (void)setAuthorModel:(AuthorModel *)authorModel {
    _authorModel = authorModel;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.authorModel.avatar] placeholderImage:[UIImage imageNamed:@"homePlaceholder"]];
    self.nameLabel.text = self.authorModel.nickname;
}

@end
