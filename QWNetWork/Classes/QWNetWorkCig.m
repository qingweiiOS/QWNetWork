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

@interface QWNetWorkCig ()
{
    NSString *_successCodeStr;
    NSInteger _successCode;
}
@end

@implementation QWNetWorkCig
@synthesize successCodeStr = _successCodeStr,successCode = _successCode;
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

- (NSString *)successCodeStr{
    if(_successCodeStr.length == 0){
        _successCodeStr = @"200";
    }
    return _successCodeStr;
}
- (NSInteger)successCode{
   
    return [self.successCodeStr integerValue];
}
- (void)setSuccessCode:(NSInteger)successCode{
    _successCode = successCode;
    _successCodeStr = [NSString stringWithFormat:@"%ld",successCode];
}
- (void)setSuccessCodeStr:(NSString *)successCodeStr{
    _successCodeStr = successCodeStr;
    _successCode = [successCodeStr integerValue];
}
@end
