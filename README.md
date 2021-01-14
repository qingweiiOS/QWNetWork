
```
pod 'QWNetWork'
```
### 一、相关组成结构

1、配置类 QWNetWorkCig

```objc
/**属性*/
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
```

配置示例配置 - 以下配置为全局配置

```objc
/**BaseURL 域名/IP*/
[QWNetWorkCig netWorkCig].BaseURL = API_BaseURL;
/** 请求成功代码 默认200
 *  如果是 '0001' 这种可以使用字符串形式的 successCodeStr
 */
[QWNetWorkCig netWorkCig].successCodeStr = @"0001";
[QWNetWorkCig netWorkCig].successCode = 200;
/**是否关闭所有请求的HUD 优先级比较低 单个请求可以单独设置 默认NO*/
[QWNetWorkCig netWorkCig].closeHUD = YES;
/**请求开始时至请求结束期间 是否禁用界面交互  优先级比较低 单个请求可以单独设置 默认NO*/
[QWNetWorkCig netWorkCig].isBanInteraction = YES;
```



2、模型类 QWBaseModel 

```objc
/// json数组格式转化为模型数组
+ (NSArray *)jsonsToModelsWithJsons:(NSArray *)jsons;
/// 获取类名
+ (NSString *)className;
/**打印所有属性，方便快捷的创建模型类 
* 例：@{@"title":@"标题",@"Count":"5"} 
* 将会打印出:
*    @property (nonatomic,assign) NSInteger Count;
*    @property (nonatomic,copy) NSString * title;
*/ 
+ (void)printPropertyWithDict:(NSDictionary *)dict;
```

使用时需要将工程中的模型类继续该类

3、响应类  QWBaseResponse

```objc
/// 请求结果编码
@property (nonatomic, copy)   NSString * code;
/// 错误信息
@property (nonatomic, copy)   NSString * message;
/// 返回数据
@property (nonatomic, strong) id data;
```

  如果和服务器返回的 字段不一样 请继承该类 在.m使用函数映射 （也就是YYModel的映射函数）

```objc
- (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{

    return @{
      //例
     @"user_id" : @"id",
     @"code" : @"服务器'code'字段"
     @"message" : @"服务器'message'字段"
     @"data" : @"服务器'data'字段"
   };
}
```

如果服务器返回的数据最外层的字段比较多 请继承该类自行添加

3、基础请求类  QWBaseRequest

属性

```objc
///请求地址
@property (nonatomic, copy)   NSString * requestURL;
/// 请求参数
@property (nonatomic, strong) NSDictionary * requestParameters;
///请求类型 默认POST
@property (nonatomic, assign) QWRequestMethod requestType;
///请求类型 String
@property (nonatomic, copy , readonly) NSString * requestTypeStr;
///数据模型 类名
@property (nonatomic, copy) NSString * modelName;
///请求头
@property (nonatomic, strong) NSDictionary * requestHead;
///响应对象类型
@property (nonatomic, copy) NSString * responseClassName;
/**请求开始时至请求结束期间 是否禁用界面交互  默认NO*/
@property (nonatomic, assign) BOOL isBanInteraction;
/*
 * 是否关闭HUD  默认不关闭 如果关闭将由自己写hud逻辑
 * 如果没有明确设置 使用全局设置  [QWNetWorkCig netWorkCig].closeHUD
 */
@property (nonatomic, assign) BOOL isCloseHUD;

///当前是否在请求
@property (nonatomic, assign, readonly) BOOL isOngoing;
///当前任务
@property (nonatomic, strong, readonly) NSURLSessionDataTask * dataTask;
///响应对象
@property (nonatomic, strong, readonly) QWBaseResponse * response;
///响应对象
@property (nonatomic, strong , readonly) NSDictionary * responseDic;
///响应对象
@property (nonatomic, strong , readonly) NSData * responseData;
```

函数

```objc
/**
 *  网络 请求1
 *  @param success    成功回调
 *  @param failure    失败回调
 *  @param progres    请求进度
 *
 *  return 当前任务
 */
- (NSURLSessionDataTask *)startRequestWithSuccess:(successBlock __nullable)success
                    failure:(failureBlock __nullable )failure
                    progres:(progressBlock __nullable)progres;
/**
 *  网络 请求2 无请求进度
 *  @param success    成功回调
 *  @param failure    失败回调
 *
 *  return 当前任务
 */
- (NSURLSessionDataTask *)startRequestWithSuccess:(successBlock __nullable)success
                                          failure:(failureBlock __nullable)failure;
/**
 *  GET   请求3
 *  @param success    成功回调
 *  @param failure    失败回调
 *  return 当前任务
 */
- (NSURLSessionDataTask *)GETRequestWithSuccess:(successBlock __nullable)success
                                        failure:(failureBlock __nullable)failure
                                        progres:(progressBlock __nullable)progres;

/**
 *  GET  请求4 无请求进度
 *  @param success    成功回调
 *  @param failure    失败回调
 *  return 当前任务
 */
- (NSURLSessionDataTask *)GETRequestWithSuccess:(successBlock __nullable)success
                                        failure:(failureBlock __nullable)failure;



/**
 *  POST 请求5
 *  @param success    成功回调
 *  @param failure    失败回调
 *  return 当前任务
 */
- (NSURLSessionDataTask *)POSTRequestWithSuccess:(successBlock __nullable)success
                                         failure:(failureBlock __nullable)failure
                                         progres:(progressBlock __nullable)progres;

/**
 *  POST 请求6 无请求进度
 *  @param success    成功回调
 *  @param failure    失败回调
 *  return 当前任务
 */
- (NSURLSessionDataTask *)POSTRequestWithSuccess:(successBlock __nullable)success
                                         failure:(failureBlock __nullable)failure;


/// 取消所有任务
- (void)cancelAllTask;
/// 取消指定任务
- (void)cancelTask;
```

如果项目中的请求有请求头或公共参数，请继承该类

 a、请求头:重写 requestHead属性的get方法 （每个请求可以单独设置请求头，且单独设置的请求头优先于公共请求头）

```objc
- (NSDictionary *)requestHead{
    if(token){
        NSMutableDictionary *header = [NSMutableDictionary dictionary];
        header[@"Authorization"] = [NSString stringWithFormat:@"Bearer %@",token];
        return header;
    }
    return nil;
}
```

b、参数 重写 publicParameters属性的get方法

```objc
- (NSDictionary *)publicParameters{
  
    return @{@"PUBLICkey":@"value"};
}
```

### 二、使用

```objc
QWBaseRequest *request = [QWBaseRequest new];
///请求路径
    request.requestURL = POST_Getusablelist;
///请求方式
         request.requestType = QWRequestMethodPOST;
    request.requestParameters = ({
        NSMutableDictionary *params = NSMutableDictionary.dictionary;
        [params setObject:@"value1" forKey:@"key1"];
        [params setObject:@"value2" forKey:@"key2"];
        [params setObject:@"value3" forKey:@"key3"];
        params;
    });
    /// 传入模型类 返回的将会自动转化为设置的模型对象 否则返回json
    request.modelName = [JTCouponModel className];
    /**
     默认的响应者 QWBaseResponse 只有3个字段 code data message 
      可能会不满足需求。这时候需要继承 QWBaseresponse 添加需要的字段
      例: JTListResponse
      /// 分页查询会有
                @property (nonatomic, assign) NSInteger totalPageSize;

                @property (nonatomic, assign) NSInteger currentPage;

                @property (nonatomic, assign) NSInteger totalSize;

                @property (nonatomic, assign) NSInteger currentPageSize;
    */ 
     request.responseClassName = [JTListResponse className];
         ///是否关闭 请求自带的HUD
            request.isCloseHUD = YES;
           ///请求期间 禁用界面交互
      request.isBanInteraction = YES;
    [request startRequestWithSuccess:^(QWBaseResponse *response) {
        //response.data 是一个  JTCouponModel对象 或者是一个 NSArray <JTCouponModel *>数组
    } failure:^(QWBaseResponse *error) {
       
    }];
```

更多函数 和属性 请看 QWBaseRequest.h

