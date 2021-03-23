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
@end
@implementation QWNetRequest
+ (AFHTTPSessionManager *)managerWithAPI:(NSString *)webServiceAPI
                          serializerType:(QWSerializerType)SerializerType{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    if(SerializerType == QWSerializerTypeHTTP){
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }else  if(SerializerType == QWSerializerTypeJSON){
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    manager.requestSerializer.timeoutInterval = 30;
    return manager;
}
+ (NSString *)requestURL:(NSString *)webServiceAPI{
    
    NSString *requestURL = webServiceAPI;
    if(requestURL.length == 0){
        @throw [NSException exceptionWithName:@"requestURL 为空" reason:@"requestURL 为空" userInfo:nil];
    }else if(![requestURL hasPrefix:@"http"]){
        NSURL *url = [NSURL URLWithString:[QWNetWorkCig netWorkCig].BaseURL];
        requestURL = [NSURL URLWithString:requestURL relativeToURL:url].absoluteString;
    }
    return requestURL;
}
+ (id)POSTWebServiceAPI:(NSString *)webServiceAPI
              parameter:(NSDictionary *)parameterDic
                   head:(NSDictionary *)headDic
         serializerType:(QWSerializerType)SerializerType
               progress:(uploadProgress)uploadProgress
                success:(requestSuccess)success
                failure:(requestFailure)failure{
    
    AFHTTPSessionManager *manager = [self managerWithAPI:webServiceAPI serializerType:SerializerType];
    NSString *requestURL = [self requestURL:webServiceAPI];
    return [manager POST:requestURL parameters:parameterDic headers:headDic progress:^(NSProgress * _Nonnull progress) {
        uploadProgress(progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}


+ (id)PUTWebServiceAPI:(NSString *)webServiceAPI
             parameter:(NSDictionary *)parameterDic
                  head:(NSDictionary *)headDic
        serializerType:(QWSerializerType)SerializerType
               success:(requestSuccess)success
               failure:(requestFailure)failure{
    
    AFHTTPSessionManager *manager = [self managerWithAPI:webServiceAPI serializerType:SerializerType];
    NSString *requestURL = [self requestURL:webServiceAPI];
    
    return [manager PUT:requestURL parameters:parameterDic headers:headDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

+ (id)HEADWebServiceAPI:(NSString *)webServiceAPI
              parameter:(NSDictionary *)parameterDic
                   head:(NSDictionary *)headDic
         serializerType:(QWSerializerType)SerializerType
                success:(requestSuccess)success
                failure:(requestFailure)failure{
    
    AFHTTPSessionManager *manager = [self managerWithAPI:webServiceAPI serializerType:SerializerType];
    NSString *requestURL = [self requestURL:webServiceAPI];
    return  [manager HEAD:requestURL parameters:parameterDic headers:headDic success:^(NSURLSessionDataTask * _Nonnull task) {
        success(nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

+ (id)DELETEWebServiceAPI:(NSString *)webServiceAPI
                parameter:(NSDictionary *)parameterDic
                     head:(NSDictionary *)headDic
           serializerType:(QWSerializerType)SerializerType
                  success:(requestSuccess)success
                  failure:(requestFailure)failure{
    AFHTTPSessionManager *manager = [self managerWithAPI:webServiceAPI serializerType:SerializerType];
    NSString *requestURL = [self requestURL:webServiceAPI];
    return  [manager DELETE:requestURL parameters:parameterDic headers:headDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (id)PATCHWebServiceAPI:(NSString *)webServiceAPI
               parameter:(NSDictionary *)parameterDic
                    head:(NSDictionary *)headDic
          serializerType:(QWSerializerType)SerializerType
                 success:(requestSuccess)success
                 failure:(requestFailure)failure{
    AFHTTPSessionManager *manager = [self managerWithAPI:webServiceAPI serializerType:SerializerType];
    NSString *requestURL = [self requestURL:webServiceAPI];
    return  [manager PATCH:requestURL parameters:parameterDic headers:headDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (id)GETWebServiceAPI:(NSString *)webServiceAPI
             parameter:(NSDictionary *)parameterDic
                  head:(NSDictionary *)headDic
        serializerType:(QWSerializerType)SerializerType
              progress:(uploadProgress)uploadProgress
               success:(requestSuccess)success
               failure:(requestFailure)failure{
    AFHTTPSessionManager *manager = [self managerWithAPI:webServiceAPI serializerType:SerializerType];
    NSString *requestURL = [self requestURL:webServiceAPI];
    
    return [manager GET:requestURL parameters:parameterDic headers:headDic progress:^(NSProgress * _Nonnull downloadProgress) {
        uploadProgress(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}
+ (id)GETWebServiceAPI:(NSString *)webServiceAPI
             parameter:(NSDictionary *)parameterDic
                  head:(NSDictionary *)headDic
        serializerType:(QWSerializerType)SerializerType
               success:(requestSuccess)success
               failure:(requestFailure)failure{
    
    AFHTTPSessionManager *manager = [self managerWithAPI:webServiceAPI serializerType:SerializerType];
    NSString *requestURL = [self requestURL:webServiceAPI];
    
    return [manager GET:requestURL parameters:parameterDic headers:headDic progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
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
