//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWNetRequest.h
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

#import <Foundation/Foundation.h>
///请求成功
typedef void(^requestSuccess)(id _Nullable data);
///请求失败
typedef void(^requestFailure)(id _Nonnull error);
///请求进度
typedef void(^uploadProgress)(NSProgress * _Nonnull uploadProgress);
///序列化类型
typedef NS_ENUM(NSInteger, QWSerializerType) {
    QWSerializerTypeHTTP = 0,
    QWSerializerTypeJSON,
};

NS_ASSUME_NONNULL_BEGIN

@interface QWNetRequest : NSObject

/**
 *  网络请求
 *
 *  @param webServiceAPI    请求地址
 *  @param parameterDic    请求参数
 *  @param headDic    请求头
 *  @param uploadProgress    上传进度
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
+ (id)POSTWebServiceAPI:(NSString *)webServiceAPI
              parameter:(NSDictionary *)parameterDic
                   head:(NSDictionary *)headDic
         serializerType:(QWSerializerType)SerializerType
               progress:(uploadProgress)uploadProgress
                success:(requestSuccess)success
                failure:(requestFailure)failure;
/**
 *  网络请求
 *
 *  @param webServiceAPI    请求地址
 *  @param parameterDic    请求参数
 *  @param headDic     请求头
 *  @param success    请求成功回调
 *  @param failure    请求失败回调
 */
+ (id)GETWebServiceAPI:(NSString *)webServiceAPI
               parameter:(NSDictionary *)parameterDic
                    head:(NSDictionary *)headDic
          serializerType:(QWSerializerType)SerializerType
                 success:(requestSuccess)success
                 failure:(requestFailure)failure;
/**
 *
 * 取消所有任务
 */
+ (void)cancelAllTask;
/**
 * 取消指定任务
 */
+ (void)cancelTask:(NSURLSessionDataTask *)task;

@end

NS_ASSUME_NONNULL_END
