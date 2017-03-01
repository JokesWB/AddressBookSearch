//
//  AddressBookTool.m
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import "AddressBookTool.h"
#import "Person.h"

@interface AddressBookTool ()

@property (nonatomic , strong) NSMutableArray *handleArray;
@property (nonatomic , strong) NSMutableArray *keysArray;    // 存储key
@property (nonatomic , strong) NSMutableArray *finalArray;   //处理后的数组
@property (nonatomic , copy) FinalBlock block;

@end

@implementation AddressBookTool

- (void)needHandleArray:(NSArray *)handleArray getFinalArray:(FinalBlock)finalBlock
{
    self.block = finalBlock;  //写到上面才可以
    [self handleArrayGetDictWithArray:handleArray];
    
}

- (void)handleArrayGetDictWithArray:(NSArray *)array
{
    for (Person *p in array) {
        NSDictionary *dic = [self getInitialWithPerson:p];
        [self.handleArray addObject:dic];
    }
//    NSLog(@"handleAray == %@", self.handleArray);
    
    // 给 key 排序
    [self.keysArray sortUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        return [obj1 compare:obj2];
    }];
    
    for (int i = 0; i < self.keysArray.count; i++) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        NSMutableArray *valuesArray = [NSMutableArray array];
        for (int j = 0; j < self.handleArray.count; j++) {
            NSDictionary *dic = self.handleArray[j];
            NSString *key = dic.allKeys.firstObject;
            if ([self.keysArray[i] isEqualToString:key]) {
                [valuesArray addObject:[dic objectForKey:key]];
            }
        }
        [dict setObject:valuesArray forKey:self.keysArray[i]];
        [self.finalArray addObject:dict];
    }
    
    if (self.block) {
        self.block(self.finalArray, self.keysArray);
    }
    
    
    
}

// 获取 姓名拼音 首字母
- (NSDictionary *)getInitialWithPerson:(Person *)p
{
    if (p.name.length == 0) {
        return [NSDictionary dictionary];
    }
    const char *c = [p.name UTF8String];
    CFStringRef str = CFStringCreateWithCString(NULL, c, kCFStringEncodingUTF8);
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, str);
    //一下两句是把汉字转换为不带声调的拼音，如只写 CFStringTransform(string, NULL, kCFStringTransformToLatin, false);  ，则会转化为带声调的拼音
    CFStringTransform(string, NULL, kCFStringTransformToLatin, false);
    CFStringTransform(string, NULL, kCFStringTransformStripCombiningMarks, false);
    // 转换成 NSString
    NSString *nString = (__bridge NSString *)(string);
    // 获取首字母
    NSString *key = [nString substringToIndex:1];

    // 存储不同的首字母 key
    if (![self.keysArray containsObject:key]) {
        [self.keysArray addObject:key];
    }
    
    NSDictionary *dic = [NSDictionary dictionaryWithObject:p forKey:key];
    return dic;
    
}


#pragma mark - 懒加载
- (NSMutableArray *)handleArray
{
    if (!_handleArray) {
        _handleArray = [NSMutableArray array];
    }
    return _handleArray;
}

- (NSMutableArray *)keysArray
{
    if (!_keysArray) {
        _keysArray = [NSMutableArray array];
    }
    return _keysArray;
}

- (NSMutableArray *)finalArray
{
    if (!_finalArray) {
        _finalArray = [NSMutableArray array];
    }
    return _finalArray;
}


@end
