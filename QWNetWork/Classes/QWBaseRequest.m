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
#import <SVProgressHUD/SVProgressHUD.h>
#import <YYModel/YYModel.h>
#import "QWBaseModel.h"
#import "QWBaseResponse.h"
#import "QWNetRequest.h"
#import "QWNetWorkCig.h"
@interface QWBaseRequest(){
    BOOL isSetHUD;
}
///请求成功
@property (nonatomic, copy) requestSuccess success;
///请求失败
@property (nonatomic, copy) requestFailure failure;
///请求进度
@property (nonatomic, copy) uploadProgress progres;
@end
@implementation QWBaseRequest

- (NSURLSessionDataTask *)startRequestWithSuccess:(successBlock)success
                                          failure:(failureBlock)failure
                                          progres:(progressBlock)progres{
    if(success)_success = success;
    if(failure)_failure = failure;
    if(progres)_failure = progres;
    if(!isSetHUD)self.isCloseHUD = [QWNetWorkCig netWorkCig].closeHUD;
    
    [self showHUD];
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
    _dataTask = [QWNetRequest POSTWebServiceAPI:self.requestURL parameter:self.requestParameters head:self.requestHead progress:^(NSProgress *uploadProgress){
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
                                          head:self.requestHead
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
        NSLog(@"%@",obj);
        _responseDic = obj;
        if([obj isKindOfClass:[NSDictionary class]]){
            response = [responseClass yy_modelWithJSON:obj];
            if([response.code isEqualToString:[QWNetWorkCig netWorkCig].requestSuccessCode]){/// 数据成功
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
    }else{
        NSLog(@"\n 参数：%@",self.requestParameters);
        NSLog(@"\n 「api」-- : %@ \n 「code」-- : %ld\n 「msg」-- : %@\n 「data」-- : %@",self.requestURL,(long)response.code,response.message,[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    }
    
    _isOngoing = NO;
    [self clearBlock];
}


- (void)clearBlock{
    _success = nil;
    _failure = nil;
    _progres = nil;
}


#pragma mark - hud
- (void)showErrorMsg:(NSString *)Msg{
    
    if(!self.isCloseHUD){
        [SVProgressHUD showErrorWithStatus:Msg];
    }
}
- (void)showSuccessMsg:(NSString *)Msg{
    
    if(!self.isCloseHUD){
        [SVProgressHUD showSuccessWithStatus:Msg];
    }
}
- (void)showHUD{
    if(!self.isCloseHUD){
        if(![SVProgressHUD isVisible]){
            [SVProgressHUD show];
        }
    }
}
- (void)dismissHUD{
   
    if(!self.isCloseHUD){
        [SVProgressHUD dismiss];
    }
}
#pragma mark - getter & setter
- (void)setIsCloseHUD:(BOOL)isCloseHUD{
    _isCloseHUD = isCloseHUD;
    isSetHUD = YES;
}
- (NSString *)responseClassName{
    
    if(_responseClassName.length == 0){
        _responseClassName = [QWBaseResponse className];
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
