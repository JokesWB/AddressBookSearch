//
//  Person.m
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import "Person.h"

@implementation Person

+ (instancetype)setName:(NSString *)name Age:(int)age Gender:(NSString *)gender
{
    Person *p = [[self alloc] init];
    p.name = name;
    p.age = age;
    p.gender = gender;
    return p;
}

@end
