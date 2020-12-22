//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWBaseResponse.h
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

#import "QWBaseModel.h"

@interface QWBaseResponse : QWBaseModel
/**
 * 如果和服务器返回的 字段不一样 请在使用函数映射 （也就是YYModel的映射函数）
 * + (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
 *      return @{
 *           @"user_id" : @"id",
 *           @"code" : @"服务器'code'字段"
 *           @"message" : @"服务器'message'字段"
 *           @"data" : @"服务器'data'字段"
 *       };
 *  }
 *  如果服务器返回的数据最外层的字段比较多 请继承该类自行添加
 */
/// 请求结果编码
@property (nonatomic, copy)   NSString * code;
/// 错误信息
@property (nonatomic, copy)   NSString * message;
/// 返回数据
@property (nonatomic, strong) id data;
@end


