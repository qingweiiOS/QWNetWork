//
/*
 *    佛              _oo0oo_         QWHUDQ
 *      主           o8888888o
 *        保         88" . "88        QWProgressHUD.h
 *          佑       (| -_- |)
 *            永     0\  =  /0        Create: 2020/12/24
 *          无     ___/`---'\___
 *         B    .' \\|     |// '.     Copyright © Mr.qing
 *       U     / \\|||  :  |||// \
 *      G     / _|||||  // |||||- \   All rights reserved.
 *            |   | \\\  -  /// |   |
 *            | \_|  ''\---/''  |_/ |
 *            \  .-\__  '-'  ___/-. /
 *          ___'. .'  /--.--\  `. .'___
 *       ."" '<  `.___\_<|>_/___.' >' "".
 *      | | :  `- \`.;`\ _ /`;.`/ - ` : | |
 *      \  \ `_.   \_ __\ /__ _/   .-` /  /
 *  =====`-.____`.___ \_____/___.-`___.-'=====
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QWProgressHUDStyle) {
    ///白
    QWProgressHUDStyleLight,
    ///黑
    QWProgressHUDStyleDark,
};
NS_ASSUME_NONNULL_BEGIN

@interface QWProgressHUD : UIView

///消失时间 全局
+ (void)setShowTime:(NSTimeInterval)showTime;
/// HUD 样式 两种 亮的暗的 -  白的黑的
+ (void)setProgressStyle:(QWProgressHUDStyle)Style;

///转圈圈
+ (void)show;
///带着文字转圈圈
+ (void)showStatus:(NSString *)status;

///画个✅
+ (void)showSuccess:(NSString *)status;
///画个❎
+ (void)showError:(NSString *)status;
///显示一段文字
+ (void)showMessage:(NSString *)status;

///画个✅
+ (void)showSuccess:(NSString *)status delayDismiss:(NSTimeInterval)delay;
///画个❎
+ (void)showError:(NSString *)status delayDismiss:(NSTimeInterval)delay;
///显示一段文字
+ (void)showMessage:(NSString *)status delayDismiss:(NSTimeInterval)delay;

///进度条
+ (void)showProgress:(CGFloat)progress status:(NSString *)status;
+ (void)showProgress:(CGFloat)progress;

///赶紧消失
+ (void)dismiss;
+ (void)dismissDelay:(NSTimeInterval)delay;

///当前是否在显示状态
+ (BOOL)isDisplay;
@end

NS_ASSUME_NONNULL_END
