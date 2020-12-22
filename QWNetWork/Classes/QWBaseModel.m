//
/*
 *    佛              _oo0oo_         QWNetWork
 *      主           o8888888o
 *        保         88" . "88        QWBaseModel.m
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

#import <YYModel/YYModel.h>
#import "QWBaseModel.h"
#include <objc/runtime.h>
#include <objc/objc.h>
@implementation QWBaseModel

+ (NSArray *)jsonsToModelsWithJsons:(NSArray *)jsons{
    NSMutableArray *models = [NSMutableArray array];
    if(![jsons isKindOfClass:[NSArray class]]){
        return @[];;
    }
    for (NSDictionary *json in jsons) {
        id model = [[self class] yy_modelWithJSON:json];
        if (model) {
            [models addObject:model];
        }
    }
    return models;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    unsigned int count ,i;
    objc_property_t *propertyArray = class_copyPropertyList([self class], &count);
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (i = 0; i < count; i++) {
        objc_property_t property = propertyArray[i];
        ///得到属性名
        NSString *proKey = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //得到属性值
        id proValue = [self valueForKey:proKey];
        //归档
        if (proValue) {
            [aCoder encodeObject:proValue forKey:proKey];
            [dic setObject:proValue forKey:proKey];
        } else {
            [aCoder encodeObject:@"" forKey:proKey];
            [dic setObject:@"" forKey:proKey];
        }
    }
    ///释放数组
    free(propertyArray);
    
}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    unsigned int count ,i;
    //得到所有属性 数组
    objc_property_t *propertyArray = class_copyPropertyList([self class], &count);
    for (i = 0; i < count; i++) {
        objc_property_t property = propertyArray[i];
        ///得到属性名
        NSString *proKey = [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        //解档
        id proValue =  [aDecoder decodeObjectForKey:proKey];
        //设置属性值
        if (proValue) {
            [self setValue:proValue forKey:proKey];
        } else {
            [self setValue:@"" forKey:proKey];
        }
    }
    ///释放数组
    free(propertyArray);
    return self;
}
+ (NSString *)className{
    return NSStringFromClass(self);
}
+ (void)printPropertyWithDict:(NSDictionary *)dict{
    if(![dict isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"不是 NSDictionary 类型");
        return;
    }
    NSMutableString *allPropertyCode = [[NSMutableString alloc]init];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *oneProperty = [[NSString alloc]init];
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")]||[obj isKindOfClass:NSClassFromString(@"__NSDictionaryI")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
            NSLog(@"%@ --- START",key);
            [self printPropertyWithDict:dict[key]];
            NSLog(@"%@ --- END",key);
        }else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]){
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;)",key];
        }else{
            oneProperty = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }
        [allPropertyCode appendFormat:@"\n%@\n",oneProperty];
    }];
    NSLog(@"%@",allPropertyCode);
}
@end
