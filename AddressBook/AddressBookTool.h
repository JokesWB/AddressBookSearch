//
//  AddressBookTool.h
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FinalBlock)(NSArray *finalArray, NSArray *sectionIndexArray);

@interface AddressBookTool : NSObject

- (void)needHandleArray:(NSArray *)handleArray getFinalArray:(FinalBlock)finalBlock;

@end
