//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWNetWorkCig.h
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

NS_ASSUME_NONNULL_BEGIN

@interface QWNetWorkCig : NSObject
+ (QWNetWorkCig *)netWorkCig;
/**BaseURL 域名/IP*/
@property (nonatomic, copy) NSString * BaseURL;
/** 请求成功代码 默认200
 *  如果是 '0001' 这种可以使用字符串形式的 successCodeStr
 */
@property (nonatomic, copy) NSString * successCodeStr;
@property (nonatomic, assign) NSInteger successCode;
/**是否关闭所有请求的HUD 优先级比较低 单个请求可以单独设置 默认NO*/
@property (nonatomic, assign) BOOL closeHUD;
/**请求开始时至请求结束期间 是否禁用界面交互  优先级比较低 单个请求可以单独设置 默认NO*/
@property (nonatomic, assign) BOOL isBanInteraction;
@end

NS_ASSUME_NONNULL_END
