//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWBaseRequest.h
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
#import "QWNetRequest.h"
@class QWBaseResponse;
/// 请求类型
typedef NS_ENUM(NSInteger, QWRequestMethod) {
    /// POST
    QWRequestMethodPOST,
    /// GET
    QWRequestMethodGET,
};

///请求成功
typedef void(^successBlock)(QWBaseResponse * _Nullable response);
///请求失败
typedef void(^failureBlock)(QWBaseResponse * _Nullable error);
///请求进度
typedef void(^progressBlock)(NSProgress * _Nonnull uploadProgress);

NS_ASSUME_NONNULL_BEGIN

@interface QWBaseRequest : NSObject
///请求结果是否缓存 默认NO
//@property (nonatomic, assign) BOOL isCache;
///请求地址
@property (nonatomic, copy)   NSString * requestURL;
/// 请求参数
@property (nonatomic, strong) NSDictionary * requestParameters;
/// 公共参数
@property (nonatomic, strong) NSDictionary * publicParameters;
///请求类型 默认POST
@property (nonatomic, assign) QWRequestMethod requestType;
///服务器接收
@property (nonatomic, assign) QWSerializerType serializerType;
///请求类型 String
@property (nonatomic, copy , readonly) NSString * requestTypeStr;
///数据模型 类名
@property (nonatomic, copy) NSString * modelName;
///请求头
@property (nonatomic, strong) NSDictionary * requestHead;
///响应对象类型
@property (nonatomic, copy) NSString * responseClassName;
/**请求开始时至请求结束期间 是否禁用界面交互  默认NO*/
@property (nonatomic, assign) BOOL isBanInteraction;
/*
 * 是否关闭HUD  默认不关闭 如果关闭将由自己写hud逻辑
 * 如果没有明确设置 使用全局设置  [QWNetWorkCig netWorkCig].closeHUD
 */
@property (nonatomic, assign) BOOL isCloseHUD;

///当前是否在请求
@property (nonatomic, assign, readonly) BOOL isOngoing;
///当前任务
@property (nonatomic, strong, readonly) NSURLSessionDataTask * dataTask;
///响应对象
@property (nonatomic, strong, readonly) QWBaseResponse * response;
///响应对象
@property (nonatomic, strong , readonly) NSDictionary * responseDic;
///响应对象
@property (nonatomic, strong , readonly) NSData * responseData;

/**
 *  网络 请求1
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param progres    请求进度
 *
 *  return 当前任务
 */
- (NSURLSessionDataTask *)startRequestWithSuccess:(successBlock __nullable)success
                    failure:(failureBlock __nullable )failure
                    progres:(progressBlock __nullable)progres;
/**
 *  网络 请求2 无请求进度
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  return 当前任务
 */
- (NSURLSessionDataTask *)startRequestWithSuccess:(successBlock __nullable)success
                                          failure:(failureBlock __nullable)failure;
/**
 *  GET   请求3
 *  @param success    成功回调
 *  @param failure    失败回调
 *  return 当前任务
 */
- (NSURLSessionDataTask *)GETRequestWithSuccess:(successBlock __nullable)success
                                        failure:(failureBlock __nullable)failure
                                        progres:(progressBlock __nullable)progres;

/**
 *  GET  请求4 无请求进度
 *  @param success    成功回调
 *  @param failure    失败回调
 *  return 当前任务
 */
- (NSURLSessionDataTask *)GETRequestWithSuccess:(successBlock __nullable)success
                                        failure:(failureBlock __nullable)failure;



/**
 *  POST 请求5
 *  @param success    成功回调
 *  @param failure    失败回调
 *  return 当前任务
 */
- (NSURLSessionDataTask *)POSTRequestWithSuccess:(successBlock __nullable)success
                                         failure:(failureBlock __nullable)failure
                                         progres:(progressBlock __nullable)progres;

/**
 *  POST 请求6 无请求进度
 *  @param success    成功回调
 *  @param failure    失败回调
 *  return 当前任务
 */
- (NSURLSessionDataTask *)POSTRequestWithSuccess:(successBlock __nullable)success
                                         failure:(failureBlock __nullable)failure;


/// 取消所有任务
- (void)cancelAllTask;
/// 取消指定任务
- (void)cancelTask;
@end

NS_ASSUME_NONNULL_END
