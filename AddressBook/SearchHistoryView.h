//
//  SearchHistoryView.h
//  AddressBook
//
//  Created by admin on 2017/2/21.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHistoryView : UIView

@property (nonatomic , strong) NSMutableArray *historyArray;
@property (nonatomic , copy) void (^clickRowBlock)(NSString *content);

@end
