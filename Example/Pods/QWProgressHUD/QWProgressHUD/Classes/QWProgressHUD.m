//
/*
 *    佛              _oo0oo_         QWHUDQ
 *      主           o8888888o
 *        保         88" . "88        QWProgressHUD.m
 *          佑       (| -_- |)
 *            永     0\  =  /0        Create: 2020/12/24
 *          无     ___/`---'\___
 *         B    .' \\|     |// '.    Copyright © 2020 Mr.qing
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

#import "QWProgressHUD.h"
/**
 *  延迟执行
 */
#define GCD_AFTER(TIME,Block) dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(TIME* NSEC_PER_SEC)), dispatch_get_main_queue(),Block);
#define QKEYWINDOW ({\
UIWindow *keyWindow;\
if (@available(iOS 13.0, *)) {\
keyWindow = [[UIApplication sharedApplication].windows firstObject];\
}else{\
keyWindow = [[UIApplication sharedApplication] keyWindow];\
}\
keyWindow;\
})
#define LIGHTColor [UIColor whiteColor]
#define DARKColor  [UIColor blackColor]
///默认高度宽度
#define HUDWIDTH 80
///最大宽度
#define MAXWIDTH 200
#define kQSCREEN_H ([UIScreen mainScreen].bounds.size.height)
#define kQSCREEN_W ([UIScreen mainScreen].bounds.size.width)
@interface QWProgressHUD()
@property (strong, nonatomic)  UIView *contentView;
@property (strong, nonatomic)  UILabel *titleLab;
@property (strong, nonatomic)  UIVisualEffectView *hudView;
@property (assign, nonatomic)  UIBlurEffectStyle blurEffectStyle;
@property (nonatomic, strong)  CAShapeLayer *shapeLayer,*progressLayer;
@property (nonatomic, copy)    NSString *messageStr;
@property (nonatomic, assign)  QWProgressHUDStyle hudStyle;
@property (nonatomic, strong)  UIColor * strokeColor;
@property (nonatomic, assign)  NSTimeInterval showTime;
@property (nonatomic, assign)  CGFloat radius;
@property (nonatomic, assign)  BOOL isDisplay;
@property (nonatomic, strong)  NSTimer *delayTimer;
@property (nonatomic, assign)  NSTimeInterval delayTime;
@end
@implementation QWProgressHUD

+ (QWProgressHUD *)instance
{
    static QWProgressHUD *progressView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        progressView = [QWProgressHUD new];
        [progressView initUI];
        if (@available(iOS 13.0, *)) {
            UIUserInterfaceStyle mode = UITraitCollection.currentTraitCollection.userInterfaceStyle;
            if (mode == UIUserInterfaceStyleDark) {
                //暗黑模式
                [progressView setHudStyle:QWProgressHUDStyleDark];
            }else{
                [progressView setHudStyle:QWProgressHUDStyleLight];
            }
        } else {
            [progressView setHudStyle:QWProgressHUDStyleLight];
        }
        progressView.showTime = 3.0;
    });
    return progressView;
}
- (NSTimer *)delayTimer
{
    if(!_delayTimer){
        _delayTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(checkHiddenTime) userInfo:nil repeats:YES];
        //暂停
        [_delayTimer setFireDate:[NSDate distantFuture]];
    }
    return _delayTimer;
}
- (void)setHudStyle:(QWProgressHUDStyle)hudStyle{
    _hudStyle = hudStyle;
    if(_hudStyle == QWProgressHUDStyleLight){
        //背景和内容相反
        self.titleLab.textColor = DARKColor;
        self.strokeColor = DARKColor;
        self.hudView.backgroundColor = [LIGHTColor colorWithAlphaComponent:0.7];
        _blurEffectStyle = UIBlurEffectStyleLight;
    }else{
        self.titleLab.textColor = LIGHTColor;
        self.strokeColor = LIGHTColor;
        self.hudView.backgroundColor = [DARKColor colorWithAlphaComponent:0.7];
        _blurEffectStyle = UIBlurEffectStyleDark;
    }
}
- (void)initUI{
    self.frame = CGRectMake(0, 0, HUDWIDTH, HUDWIDTH);
    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor clearColor];
    self.hudView = [[UIVisualEffectView alloc] initWithFrame:self.bounds];
    [self addSubview:self.hudView];
    self.titleLab = [UILabel new];
    self.titleLab.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 20);
    self.titleLab.font = [UIFont systemFontOfSize:15];
    self.titleLab.numberOfLines = 0;
    self.titleLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.titleLab];
    self.contentView = [UIView new];
    [self addSubview:self.contentView];
    self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-20);
}
- (void)updateUI{
    self.titleLab.text = self.messageStr;
  
    if(self.messageStr.length){
      CGSize maxSize =   [self calculate];
        if(maxSize.height<21){
            //+10 ??? titleLab 到两边的距离和
            self.frame = CGRectMake(0, 0, ((maxSize.width+10)>HUDWIDTH)?(maxSize.width+10):HUDWIDTH, HUDWIDTH);
        }else{
            self.frame = CGRectMake(0, 0, MAXWIDTH+10, HUDWIDTH+maxSize.height-20);
        }
        self.titleLab.frame = CGRectMake(5, HUDWIDTH - 25, self.frame.size.width-10, self.frame.size.height-HUDWIDTH+20);
        self.contentView.frame = CGRectMake(0, 0, HUDWIDTH, HUDWIDTH-20);
        self.contentView.center = CGPointMake(self.frame.size.width/2, HUDWIDTH/2-10);
    }else{
        self.frame = CGRectMake(0, 0, HUDWIDTH, HUDWIDTH);
        self.titleLab.frame = CGRectMake(0, self.frame.size.height-20, self.frame.size.width, 0);
        self.contentView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:_blurEffectStyle];
    self.hudView.effect = blurEffect;
    self.hudView.frame = self.bounds;
}
#pragma mark - Private Methods
- (void)resetUI{
    self.titleLab.text = @"";
    [self removeFromSuperview];
    [self.contentView.layer removeAllAnimations];
    [self.shapeLayer removeFromSuperlayer];
    [self.shapeLayer removeAllAnimations];
    [self.progressLayer removeFromSuperlayer];
    [self.progressLayer removeAllAnimations];
    [self.layer removeAllAnimations];
    self.shapeLayer = nil;
    self.progressLayer = nil;
    self.isDisplay = NO;
    [self.delayTimer setFireDate:[NSDate distantFuture]];
    self.delayTime = 0.0;
}
- (void)showTitle:(NSString *)msg{
    [self resetUI];
    _isDisplay = YES;
    _messageStr = msg;
    [self updateUI];
    [self show];
}
- (void)showMessage:(NSString *)msg{
    if(msg.length == 0){
        return;
    }
    [self resetUI];
    _isDisplay = YES;
    _messageStr = msg;
    [self updateMessageUI];
    [self show];
    
}
- (void)show{
    self.center = QKEYWINDOW.center;
    [QKEYWINDOW addSubview:self];
}
- (void)updateMessageUI{
    self.titleLab.text = self.messageStr;
    CGSize maxSize = [self calculate];
    CGFloat height,width;
    height = maxSize.height+20;
    
    if(maxSize.height<21){
        width = ((maxSize.width+20)>HUDWIDTH)?(maxSize.width+20):HUDWIDTH;
        
    }else{
        width =  MAXWIDTH+20;
    }
    self.frame = CGRectMake(0, 0, width, height);
    self.titleLab.frame = CGRectMake(10, 10, width-20, height-20);
    self.contentView.frame = CGRectZero;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:_blurEffectStyle];
    self.hudView.effect = blurEffect;
    self.hudView.frame = self.bounds;
    
}
- (void)dismiss{
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.alpha = 1.0;
        self.transform = CGAffineTransformIdentity;
        if(finished){
            [self resetUI];
        }else{
            NSLog(@"动画移除");
        }
    }];
}
- (CGSize)calculate{
    // 是否小于一行
    NSMutableParagraphStyle *npgStyle = [[NSMutableParagraphStyle alloc] init];
    npgStyle.alignment = NSTextAlignmentCenter;
    npgStyle.maximumLineHeight = 20;
    npgStyle.minimumLineHeight = 20;
    NSDictionary *attr = @{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:npgStyle};
    CGSize size = CGSizeMake(MAXWIDTH, MAXFLOAT);
    NSString *displayStr = [self.messageStr stringByAppendingString:@""];
    CGSize maxSize = [displayStr boundingRectWithSize:size
                                              options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                           attributes:attr context:nil].size;
    NSLog(@"maxSize:%@", [NSValue valueWithCGSize:maxSize]);
   
    return maxSize;
}

#pragma mark - animation
///构建✅路径
- (void)drawSuccess{
    CGPoint center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath moveToPoint:CGPointMake(center.x-20, center.y-5)];
    [circlePath addLineToPoint:CGPointMake(center.x-5, center.y+10)];
    [circlePath addLineToPoint:CGPointMake(center.x+20, center.y-15)];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = circlePath.CGPath;
    shapeLayer.strokeColor = self.strokeColor.CGColor;
    shapeLayer.fillColor =   [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineCapRound;
    self.shapeLayer = shapeLayer;
    [self.contentView.layer addSublayer:self.shapeLayer];
    [self strokeEndAnimation:1];
}
///构建❎路径
- (void)drawError{
    CGPoint center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
    UIBezierPath *circlePath = [UIBezierPath bezierPath];
    [circlePath moveToPoint:CGPointMake(center.x-15, center.y-15)];
    [circlePath addLineToPoint:CGPointMake(center.x+15, center.y+15)];
    [circlePath moveToPoint:CGPointMake(center.x-15, center.y+15)];
    [circlePath addLineToPoint:CGPointMake(center.x+15, center.y-15)];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = circlePath.CGPath;
    shapeLayer.strokeColor = self.strokeColor.CGColor;
    shapeLayer.fillColor =   [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 3.0;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineJoin = kCALineCapRound;
    self.shapeLayer = shapeLayer;
    [self.contentView.layer addSublayer:self.shapeLayer];
    [self strokeEndAnimation:1];
    
}
///绘制路径
- (void)strokeEndAnimation:(CGFloat)toValue{
    ///strokeEnd 绘制路径
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = 0.75;
    strokeEndAnimation.fromValue = @0;
    strokeEndAnimation.toValue = @(toValue);
    strokeEndAnimation.removedOnCompletion = YES;
    strokeEndAnimation.fillMode = kCAFillModeForwards;
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [self.shapeLayer addAnimation:strokeEndAnimation forKey:@"strokeEnd-layer"];
    
}
///进行中动画
- (void)drawOngoing{
    
    self.shapeLayer = [self drawArc:2.0 storkColor:self.strokeColor startAngle:-M_PI_2 endAngle:M_PI+M_PI_4];
    [self ongoingAnimation];
}
///
///构建一个⭕️路径
- (CAShapeLayer *)drawArc:(CGFloat)lineWith storkColor:(UIColor *)storkColor startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle {
    CGPoint center = CGPointMake(self.contentView.frame.size.width/2, self.contentView.frame.size.height/2);
    _radius = HUDWIDTH/2-15;
    if(_messageStr.length>0){
        
        _radius-=5;
    }
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:_radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    CAShapeLayer * shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = circlePath.CGPath;
    shapeLayer.strokeColor = storkColor.CGColor;
    shapeLayer.fillColor =   [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = lineWith;
    shapeLayer.lineCap = kCALineCapRound;
    [self.contentView.layer addSublayer:shapeLayer];
    return  shapeLayer;
}
///进度HUD
- (void)drawProgress:(CGFloat)progress{
    self.shapeLayer = [self drawArc:3.0 storkColor:DARKColor startAngle:-M_PI_2 endAngle:M_PI+M_PI_2] ;
    self.progressLayer = [self drawArc:3.0 storkColor:LIGHTColor startAngle:-M_PI_2 endAngle:-M_PI_2+M_PI*2*progress] ;
}
- (void)ongoingAnimation{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.0; // 动画持续时间
    animation.repeatCount = MAXFLOAT; // 重复次数
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat:M_PI*2];
    [self.contentView.layer addAnimation:animation forKey:@"rotate-layer"];
}
- (void)delayDismiss:(NSTimeInterval)delay{
    if(delay<0){
        [self dismiss];
        return;
    }
    _delayTime = self.showTime - delay;
    [self.delayTimer setFireDate:[NSDate distantPast]];
}

- (void)checkHiddenTime{
    _delayTime+=0.5;
    if(_delayTime>=self.showTime){
        
        [self dismiss];
    }
    
}
#pragma mark - Public Methods
+ (void)show{
    [self showStatus:@""];
}
+ (void)showStatus:(NSString *)status{
    [[self instance] showTitle:status];
    [[self instance] drawOngoing];
}

///画个✅
+ (void)showSuccess:(NSString *)status{
    [self showSuccess:status delayDismiss:[self instance].showTime];
}
+ (void)showSuccess:(NSString *)status delayDismiss:(NSTimeInterval)delay{
    [[self instance] showTitle:status];
    [[self instance] drawSuccess];
    [[self instance] delayDismiss:delay];
}

+ (void)showError:(NSString *)status{
    [self showError:status delayDismiss:[self instance].showTime];
}
///画个❎
+ (void)showError:(NSString *)status delayDismiss:(NSTimeInterval)delay{
    [[self instance] showTitle:status];
    [[self instance] drawError];
    [[self instance] delayDismiss:delay];
}

+ (void)dismiss{
    [[self instance] dismiss];
}

+ (void)dismissDelay:(NSTimeInterval)delay{
    [[self instance] delayDismiss:delay];
}

+ (void)setProgressStyle:(QWProgressHUDStyle)Style{
    [[self instance] setHudStyle:Style];
}

+ (BOOL)isDisplay{
    return [self instance].isDisplay;
}

+ (void)setShowTime:(NSTimeInterval)showTime{
    if(showTime<=0){
        showTime = 3;
    }
    [self instance].showTime = showTime;
}

+(void)showProgress:(CGFloat)progress{
    [self showProgress:progress status:@""];
}
+ (void)showProgress:(CGFloat)progress status:(NSString *)status{
    if(progress>1.0){
        progress = 1.0;
    }
    if(progress<0.0){
        progress = 0.0;
    }
    [[self instance] showTitle:status];
    [[self instance] drawProgress:progress];
}

+ (void)showMessage:(NSString *)status{
    [self showMessage:status delayDismiss:[self instance].showTime];
}
///显示一段文字
+ (void)showMessage:(NSString *)status delayDismiss:(NSTimeInterval)delay{
    [[self instance] showMessage:status];
    [[self instance] delayDismiss:delay];
}
@end
