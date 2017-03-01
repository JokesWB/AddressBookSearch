//
//  SearchResultViewController.h
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultViewController : UIViewController

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) NSArray *searchArrayList;
@property (nonatomic , strong) UISearchBar *searchBar;

@end
