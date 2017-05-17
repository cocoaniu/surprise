//
//  DQAFNetworkTool.h
//  Test
//
//  Created by 董强 on 15/11/6.
//  Copyright © 2015年 董强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DQResposeStyle) {
    DQJSON,
    DQXML,
    DQData,
};

typedef NS_ENUM(NSUInteger, DQRequestStyle) {
    RequestJSON,
    RequestString,
    RequestDefault
};


@interface DQAFNetworkTool : NSObject


+ (void)getUrl:(NSString *)url
          body:(id)body
      response:(DQResposeStyle)style
requestHeadFile:(NSDictionary *)headFile
       success:(void (^)(NSURLSessionDataTask *task, id resposeObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



+ (void)postUrlString:(NSString *)url
                 body:(id)body
              showHUD:(BOOL)showHUD
             showView:(UIView *)showView
             response:(DQResposeStyle)style
            bodyStyle:(DQRequestStyle)bodyStyle
      requestHeadFile:(NSDictionary *)headFile
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


@end
