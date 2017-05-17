//
//  ImageAlbumModel.m
//  xiuxiu
//
//  Created by edz on 2017/5/12.
//  Copyright © 2017年 com.cocoa_niu. All rights reserved.
//

#import "ImageAlbumModel.h"

@implementation ImageAlbumModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"coverList"]) {
        if ([value isKindOfClass:[NSArray class]]) {
            self.coverListArray = [NSMutableArray array];
            for (NSDictionary *dict in value) {
                [self.coverListArray addObject:[dict valueForKey:@"url"]];
            }
        }
    }
}


@end
