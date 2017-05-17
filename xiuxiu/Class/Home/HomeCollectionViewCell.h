//
//  HomeCollectionViewCell.h
//  xiuxiu
//
//  Created by edz on 2017/5/12.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AuthorModel.h"

@interface HomeCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic, strong) AuthorModel *authorModel;

@end
