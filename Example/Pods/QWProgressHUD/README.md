# QWProgressHUD
# 具体使用请看dome

```ruby
pod 'QWProgressHUD', '~> 0.1.0'
```
```objc
///消失时间 全局
+ (void)setShowTime:(NSTimeInterval)showTime;
/// HUD 样式 两种 亮的暗的 -  白的黑的
+ (void)setProgressStyle:(QWProgressHUDStyle)Style;


/**
* 以上下个方法需要自己调用 dissmiss方法
*/
///转圈圈
+ (void)show;
///带着文字转圈圈
+ (void)showStatus:(NSString *)status;
///进度条
+ (void)showProgress:(CGFloat)progress status:(NSString *)status;
+ (void)showProgress:(CGFloat)progress;



/**
* 以下3个方法 会在showTime时间后自动调用dismiss方法
*/ 
///画个✅
+ (void)showSuccess:(NSString *)status;
///画个❎
+ (void)showError:(NSString *)status;
///显示一段文字
+ (void)showMessage:(NSString *)status;


/**
* 以下3个方法 会在delay（参数）时间后自动调用dismiss方法
*/ 

///画个✅
+ (void)showSuccess:(NSString *)status delayDismiss:(NSTimeInterval)delay;
///画个❎
+ (void)showError:(NSString *)status delayDismiss:(NSTimeInterval)delay;
///显示一段文字
+ (void)showMessage:(NSString *)status delayDismiss:(NSTimeInterval)delay;

///赶紧消失
+ (void)dismiss;
+ (void)dismissDelay:(NSTimeInterval)delay;

///当前是否在显示状态
+ (BOOL)isDisplay;
```
## Author

Mr.qing, qingwei2013@foxmail.com

## License

QWProgressHUD is available under the MIT license. See the LICENSE file for more info.
