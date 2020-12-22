//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWNetWorkCig.m
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

#import "QWNetWorkCig.h"


@implementation QWNetWorkCig
+ (QWNetWorkCig *)netWorkCig{
    static QWNetWorkCig *newCig;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        newCig = [[QWNetWorkCig alloc] init];
    });
    return newCig;
}
- (NSString *)BaseURL{
    if(_BaseURL.length==0){
        @throw [NSException exceptionWithName:@"_BaseURL 为空:请在Appdelegate中配置 [QWNetWorkCig netWorkCig].BaseURL = BaseURL" reason:@"requestURL 为空" userInfo:nil];
    }
    return _BaseURL;
}

- (NSString *)requestSuccessCode{
    
    if(_requestSuccessCode.length == 0){
        _requestSuccessCode = @"200";
    }
    return _requestSuccessCode;
}
@end
