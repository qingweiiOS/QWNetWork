//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWNetRequest.m
 *          佑       (| -_- |)
 *            永     0\  =  /0        Create: 2020/12/22
 *          无     ___/`---'\___
 *         B    .' \\|     |// '.    Copyright © 2020 Mr.Q
 *       U     / \\|||  :  |||// \
 *      G     / _|||||  // |||||- \  All rights reserved.
 *            |   | \\\  -  /// |   |
 *            | \_|  ''\---/''  |_/ |
 *            \  .-\__  '-'  ___/-. /
 *          ___'. .'  /--.--\  `. .'___
 *       ."" '<  `.___\_<|>_/___.' >' "".
 *      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
 *      \  \ `_.   \_ __\ /__ _/   .-` /  /
 *  =====`-.____`.___ \_____/___.-`___.-'=====
 */

#import "QWNetRequest.h"
#import <AFNetworking/AFNetworking.h>
#import "QWNetWorkCig.h"
@interface QWNetRequest ()
@property (strong,nonatomic) AFHTTPSessionManager *manager;
@end
@implementation QWNetRequest
+ (id)POSTWebServiceAPI:(NSString *)webServiceAPI
              parameter:(NSDictionary *)parameterDic
                   head:(NSDictionary *)headDic
               progress:(uploadProgress)uploadProgress
                success:(requestSuccess)requestSuccess
                failure:(requestFailure)requestFailure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    NSString *requestURL = webServiceAPI;
    if(requestURL.length == 0){
        @throw [NSException exceptionWithName:@"requestURL 为空" reason:@"requestURL 为空" userInfo:nil];
    }else if(![requestURL hasPrefix:@"http"]){
        requestURL = [NSString stringWithFormat:@"%@%@",[QWNetWorkCig netWorkCig].BaseURL,requestURL];
    }
    
    return [manager POST:requestURL parameters:parameterDic headers:headDic progress:^(NSProgress * _Nonnull progress) {
        uploadProgress(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        requestSuccess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        requestFailure(error);
    }];
}
+ (id)GETWebServiceAPI:(NSString *)webServiceAPI
             parameter:(NSDictionary *)parameterDic
                  head:(NSDictionary *)headDic
               success:(requestSuccess)requestSuccess
               failure:(requestFailure)requestFailure{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    manager.requestSerializer =  [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    NSString *requestURL = webServiceAPI;
    if(requestURL.length == 0){
        @throw [NSException exceptionWithName:@"requestURL 为空" reason:@"requestURL 为空" userInfo:nil];
    }else if(![requestURL hasPrefix:@"http"]){
        requestURL = [NSString stringWithFormat:@"%@%@",[QWNetWorkCig netWorkCig].BaseURL,requestURL];
    }
    return [manager GET:requestURL parameters:parameterDic headers:headDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        requestSuccess(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        requestFailure(error);
    }];
}

+ (void)cancelAllTask{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if ([manager.tasks count] > 0) {
        [manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    }
}
+ (void)cancelTask:(NSURLSessionDataTask *)task{
    if(task){
        [task cancel];
    }
}
@end
