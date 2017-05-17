//


#import "DQAFNetworkTool.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"

@implementation DQAFNetworkTool


+ (void)getUrl:(NSString *)url
          body:(id)body
      response:(DQResposeStyle)style
requestHeadFile:(NSDictionary *)headFile
       success:(void (^)(NSURLSessionDataTask *task, id resposeObject))success
       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    // 1. 获取单例的网络管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    
    // 2. 根据 style 的类型, 去选择返回值的类型
    switch (style) {
        case DQJSON:
            
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
            
        case DQXML:
            
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
            
        case DQData:
            
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
            
        default:
            break;
    }
    
    
    // 3. 设置响应数据支持类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/x-www-form-urlencoded",@"application/x-javascript", nil]];
    
    
    // 4. 外面用字典形式将请求头传入方法 , 给网络请求加请求头
    if (headFile) {
        for (NSString *key in headFile.allKeys) {
            
            [manager.requestSerializer setValue:headFile[key] forHTTPHeaderField:key];
            
        }
    }
    
    
    // 5. UTF8转码
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    
    // 6. 发送 GET 请求
    [manager GET:url parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        /* ************************************************** */
        //如果请求成功 , 回调请求到的数据 , 同时 在这里 做本地缓存
        NSString *path = [NSString stringWithFormat:@"%ld.plist", [url hash]];
        // 存储的沙盒路径
        NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        // 归档
        [NSKeyedArchiver archiveRootObject:responseObject toFile:[path_doc stringByAppendingPathComponent:path]];
        
        
        /* if判断， 防止success 为空 */
        
        
        if (success) {
            
            success(task, responseObject);

        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
            
            /* *************************************************** */
            // 在这里读取本地缓存
            NSString *path = [NSString stringWithFormat:@"%ld.plist", [url hash]];

            NSString *path_doc = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            
            id result = [NSKeyedUnarchiver unarchiveObjectWithFile:[path_doc stringByAppendingPathComponent:path]];
            
            if (result) {
                
                success(task, result);
           
            } else {
                
                failure(task,error);
            }
        
        
//            if (failure) {
//   
//                failure(task, error);
//            
//            }
        }
        
    }];

}




+ (void)postUrlString:(NSString *)url
                 body:(id)body
              showHUD:(BOOL)showHUD
             showView:(UIView *)showView
             response:(DQResposeStyle)style
            bodyStyle:(DQRequestStyle)bodyStyle
      requestHeadFile:(NSDictionary *)headFile
              success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
              failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    // 1.获取Session管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
 
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy new];
    //是否可以使用自建证书（不花钱的）
    securityPolicy.allowInvalidCertificates=YES;
    //是否验证域名（一般不验证）
    securityPolicy.validatesDomainName=NO;
    
    [manager setSecurityPolicy:securityPolicy];
    
    if (showHUD==YES) {
        if (showView) {
            [MBProgressHUD showHUDAddedTo:showView animated:YES];
        } else {
            [MBProgressHUD showHUDAddedTo:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
        }
    }
    
    // 2.设置网络请求返回时, responseObject的数据类型
    switch (style) {
        case DQJSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case DQXML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case DQData:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    // 3.判断body体的类型
    switch (bodyStyle) {
        case RequestJSON:
            // 以JSON格式发送
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        case RequestString:
            // 保持字符串样式
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError *__autoreleasing *error) {
                return parameters;
            }];
        case RequestDefault:
            // 默认情况会把JSON拼接成字符串, 但是没有顺序
            break;
            
        default:
            break;
    }
    
    
    // 4.给网络请求加请求头
    if (headFile) {
        for (NSString *key in headFile.allKeys) {
            [manager.requestSerializer setValue:headFile[key] forHTTPHeaderField:key];
        }
    }

    // 5.设置支持的响应头格式
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/x-javascript", nil]];
    
    // 6.发送网络请求
    [manager POST:url parameters:body success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            if (showHUD) {
                if (showView) {
                    [MBProgressHUD hideHUDForView:showView animated:YES];
                } else {
                    [MBProgressHUD hideHUDForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
                }
            }
            success(task, responseObject);
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            if (showHUD) {
                if (showView) {
                    [MBProgressHUD hideHUDForView:showView animated:YES];
                } else {
                    [MBProgressHUD hideHUDForView:(UIView*)[[[UIApplication sharedApplication]delegate]window] animated:YES];
                }
            }
            failure(task, error);
        }
    }];
    
    
}

@end
