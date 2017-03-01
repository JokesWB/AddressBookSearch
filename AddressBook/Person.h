//
//  Person.h
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (nonatomic , copy) NSString *name;
@property (nonatomic , copy) NSString *gender;
@property (nonatomic , assign) int age;

+ (instancetype)setName:(NSString *)name Age:(int)age Gender:(NSString *)gender;

@end
