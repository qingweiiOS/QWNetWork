//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWBaseRequest.m
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
#define QWEAKSELF   __weak typeof(&*self)weakSelf = self;
/**
 *  回到主线程
 */
#define GCD_MAIN(Block) dispatch_async(dispatch_get_main_queue(),Block);

#import "QWBaseRequest.h"
#import <QWProgressHUD/QWProgressHUD.h>
#import <YYModel/YYModel.h>
#import "QWBaseModel.h"
#import "QWBaseResponse.h"
#import "QWNetRequest.h"
#import "QWNetWorkCig.h"
@interface QWBaseRequest(){
    /**当前请求是否设置了isCloseHUD属性，未设置就使用全局配置*/
    BOOL isSetHUD;
    /**当前请求是否设置了isBanInteraction属性，未设置使用全局配置*/
    BOOL isSetBanInteraction;
    
    NSDictionary *headDic;
}
/**请求成功*/
@property (nonatomic, copy) successBlock success;
/**请求失败*/
@property (nonatomic, copy) failureBlock failure;
/**请求进度*/
@property (nonatomic, copy) progressBlock progres;

@end
@implementation QWBaseRequest

- (NSURLSessionDataTask *)startRequestWithSuccess:(successBlock)success
                                          failure:(failureBlock)failure
                                          progres:(progressBlock)progres{
    if(success)_success = success;
    if(failure)_failure = failure;
    if(progres)_progres = progres;
    /**当前请求是否设置了isCloseHUD属性，未设置就使用全局配置*/
    if(!isSetHUD)self.isCloseHUD = [QWNetWorkCig netWorkCig].closeHUD;
    [self showHUD];
    
    /**当前请求是否设置了isBanInteraction属性，未设置使用全局配置*/
    if(!isSetBanInteraction)self.isBanInteraction = [QWNetWorkCig netWorkCig].isBanInteraction;
    if(self.isBanInteraction){
        [self currentViewController].view.userInteractionEnabled = NO;
    }
    /// 是否有公共参数追加
    if(self.publicParameters.count>0){
        NSMutableDictionary *requestDic = [NSMutableDictionary dictionaryWithDictionary:self.requestParameters];
        [requestDic addEntriesFromDictionary:self.publicParameters];
        self.requestParameters = requestDic;
    }
    /** 优先使用 当前请求的请求头 ，如果当前请求头未设置请求头 尝试加载公共请求头（继承当前类，重写requestHead属性的get方法）*/
    NSDictionary *headDic = _requestHead;
    if(!headDic){
        headDic = self.requestHead;
    }
    
    _isOngoing = YES;
    if(self.requestType == QWRequestMethodPOST){
        return [self post];
    }else{
        return  [self get];
    }
}

- (NSURLSessionDataTask *)startRequestWithSuccess:(successBlock)success
                                          failure:(failureBlock)failure{
    return [self startRequestWithSuccess:success failure:failure progres:nil];
}

- (NSURLSessionDataTask *)GETRequestWithSuccess:(successBlock)success
                                        failure:(failureBlock)failure
                                        progres:(progressBlock)progres{
    self.requestType = QWRequestMethodGET;
    return [self startRequestWithSuccess:success failure:failure progres:progres];
}

- (NSURLSessionDataTask *)GETRequestWithSuccess:(successBlock)success
                                        failure:(failureBlock)failure{
    self.requestType = QWRequestMethodGET;
    return [self startRequestWithSuccess:success failure:failure progres:nil];
}
- (NSURLSessionDataTask *)POSTRequestWithSuccess:(successBlock)success
                                         failure:(failureBlock)failure
                                         progres:(progressBlock)progres{
    self.requestType = QWRequestMethodPOST;
    return [self startRequestWithSuccess:success failure:failure progres:progres];
}

- (NSURLSessionDataTask *)POSTRequestWithSuccess:(successBlock)success
                                         failure:(failureBlock)failure{
    self.requestType = QWRequestMethodPOST;
    return [self startRequestWithSuccess:success failure:failure progres:Nil];
}


- (void)cancelAllTask
{
    [QWNetRequest cancelAllTask];
}
- (void)cancelTask{
    [QWNetRequest cancelTask:_dataTask];
}


#pragma mark - 内部函数
- (NSURLSessionDataTask * )post{
    QWEAKSELF
  
    _dataTask = [QWNetRequest POSTWebServiceAPI:self.requestURL parameter:self.requestParameters head:headDic progress:^(NSProgress *uploadProgress){
        if(weakSelf.progres) weakSelf.progres(uploadProgress);
    }success:^(id data) {
        GCD_MAIN(^{
            [self optionData:data orError:nil];
        })
    }failure:^(id error) {
        GCD_MAIN(^{
            [self optionData:nil orError:error];
        })
    }];
    return _dataTask;
}
- (NSURLSessionDataTask *)get{
    _dataTask = [QWNetRequest GETWebServiceAPI:self.requestURL
                                     parameter:self.requestParameters
                                          head:headDic
                                       success:^(id data) {
        GCD_MAIN(^{
            [self optionData:data orError:nil];
        })
    }failure:^(id error) {
        GCD_MAIN(^{
            [self optionData:nil orError:error];
        })
    }];
    return _dataTask;
}
- (void)optionData:(id)responseObject orError:(NSError *)error{
    [self dismissHUD];
    if(self.isBanInteraction){
        [self currentViewController].view.userInteractionEnabled = YES;
    }
    Class responseClass = NSClassFromString(self.responseClassName);
    QWBaseResponse *response;
    _responseData = responseObject;
    if(error){
        response = [[responseClass alloc] init];
        response.code = [NSString stringWithFormat:@"%ld",error.code];
        response.message =  [error.userInfo objectForKey:NSLocalizedDescriptionKey];
        [self showErrorMsg:response.message];
        _response = response;
        _responseDic = error.userInfo;
        if(_failure){
            _failure(response);
        }
        
    }else{
        NSDictionary *obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        _responseDic = obj;
        if([obj isKindOfClass:[NSDictionary class]]){
            response = [responseClass yy_modelWithJSON:obj];
            if([response.code isEqualToString:[QWNetWorkCig netWorkCig].successCodeStr]){/// 数据成功
                [self showSuccessMsg:response.message];
                [QWBaseModel printPropertyWithDict:response.data];
                if(self.modelName.length>0){
                    Class mClass = NSClassFromString(self.modelName);
                    if([response.data isKindOfClass:[NSArray class]]){
                        if([response.data count]==0){
                            response.data = nil;
                        }else{
                            NSArray *modelArray = [mClass jsonsToModelsWithJsons:response.data];
                            response.data = modelArray;
                        }
                    }else{
                        if([response.data count]==0){
                            response.data = nil;
                        }else{
                            response.data = [mClass yy_modelWithJSON:response.data];
                        }
                    }
                }
                _response = response;
                if(_success){
                    _success(response);
                }
                
            }else{
                
                [self showErrorMsg:response.message];
                _response = response;
                if(_failure){
                    _failure(response);
                }
                
            }
        }else{
            /// 数据解析失败
            response = [[responseClass alloc] init];
            response.code = [NSString stringWithFormat:@"-1000"];
            response.message = @"数据解析失败,请稍后在试!";
            [self showErrorMsg:response.message];
            _response = response;
            if(_failure){
                _failure(response);
            }
            
        }
        
    }
    if(error){
        NSLog(@"\n 「api」-- : %@ \n 「code」-- : %ld\n 「msg」-- : %@",self.requestURL,(long)response.code,response.message);
        NSLog(@"\n 参数：%@",self.requestParameters);
        NSLog(@"\n 「errorData」-- : %@",[[NSString alloc] initWithData:[error.userInfo objectForKey:@"com.alamofire.serialization.response.error.data"] encoding:NSUTF8StringEncoding]);
    }
    _isOngoing = NO;
    [self clearBlock];
}
- (void)clearBlock{
    _success = nil;
    _failure = nil;
    _progres = nil;
}

- (UIViewController *)rootViewController{
    
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    NSAssert(window, @"The window is empty");
    return window.rootViewController;
}
- (UIViewController *)currentViewController{
    
    UIViewController* currentViewController = [self rootViewController];
    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            
            currentViewController = currentViewController.presentedViewController;
        } else if ([currentViewController isKindOfClass:[UINavigationController class]]) {
            
            UINavigationController* navigationController = (UINavigationController* )currentViewController;
            currentViewController = [navigationController.childViewControllers lastObject];
            
        } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
            
            UITabBarController* tabBarController = (UITabBarController* )currentViewController;
            currentViewController = tabBarController.selectedViewController;
        }else{
            runLoopFind = NO;
        }
        
    }
    return currentViewController;
}

#pragma mark - hud
- (void)showErrorMsg:(NSString *)Msg{
    if(!self.isCloseHUD){
        [QWProgressHUD showError:Msg];
    }
}
- (void)showSuccessMsg:(NSString *)Msg{
    
    if(!self.isCloseHUD){
        [QWProgressHUD showSuccess:Msg];
    }
}
- (void)showHUD{
    if(!self.isCloseHUD){
        if(![QWProgressHUD isDisplay]){
            [QWProgressHUD show];
        }
    }
}
- (void)dismissHUD{
    if(!self.isCloseHUD){
        [QWProgressHUD dismiss];
    }
}
#pragma mark - getter & setter
- (void)setIsCloseHUD:(BOOL)isCloseHUD{
    _isCloseHUD = isCloseHUD;
    isSetHUD = YES;
}
- (void)setIsBanInteraction:(BOOL)isBanInteraction{
    _isBanInteraction = isBanInteraction;
    isSetBanInteraction = YES;
}
- (NSString *)responseClassName{
    
    if(_responseClassName.length == 0){
        _responseClassName = NSStringFromClass([QWBaseResponse class]);
    }
    return _responseClassName;
}
- (QWRequestMethod)requestType{
    return _requestType;
}
- (NSString *)modelName{
    return _modelName;
}
- (NSString *)requestTypeStr{
    NSString *requestTypeStr = @"POST";
    switch (_requestType) {
        case QWRequestMethodGET:
            requestTypeStr =  @"GET";
            break;
        default:
            break;
    }
    return requestTypeStr;
}
@end
