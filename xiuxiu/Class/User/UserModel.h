//
//  userModel.h
//  xiuxiu
//
//  Created by edz on 2017/5/16.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject

@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *coverUrl;
@property (nonatomic, copy) NSString *albumCount;
@property (nonatomic, copy) NSString *videoCount;

@end
