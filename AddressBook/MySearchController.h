//
//  MySearchController.h
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MySearchController : NSObject

@property (nonatomic , strong) NSArray *sourceArray;

+ (instancetype)defalutSearchController;

- (UISearchBar *)configSearchController;



@end
