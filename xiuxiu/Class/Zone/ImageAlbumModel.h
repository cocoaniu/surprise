//
//  ImageAlbumModel.h
//  xiuxiu
//
//  Created by edz on 2017/5/12.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageAlbumModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *browseUrl;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *postTime;
@property (nonatomic, strong) NSMutableArray *coverListArray;

@end
