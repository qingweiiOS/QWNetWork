//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWBaseModel.h
 *          佑       (| -_- |)
 *            永     0\  =  /0        Create: 2020/12/22
 *          无     ___/`---'\___
 *         B    .' \\|     |// '.    Copyright © 2020 Mr.Q
 *       U     / \\|||  :  |||// \
 *      G     / _|||||  // |||||- \  All rights reserved.
 *            |   | \\\  -  /// |  |
 *            | \_|  ''\---/''  |_/|
 *            \  .-\__  '-'  ___/-./
 *          ___'. .'  /--.--\  `. .'___
 *       ."" '<  `.___\_<|>_/___.' >' "".
 *      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
 *      \  \ `_.   \_ __\ /__ _/   .-` /  /
 *  =====`-.____`.___ \_____/___.-`___.-'=====
 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QWBaseModel : NSObject <NSCoding>
/// json数组格式转化为模型数组
+ (NSArray *)jsonsToModelsWithJsons:(NSArray *)jsons;
/// 获取类名
+ (NSString *)className;
/// 打印所有属性，强烈建议试一试这个方法 方便快捷的创建模型类
+ (void)printPropertyWithDict:(NSDictionary *)dict;
@end

NS_ASSUME_NONNULL_END
