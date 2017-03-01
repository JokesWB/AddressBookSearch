//
//  MySearchController.m
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import "MySearchController.h"
#import "SearchResultViewController.h"
#import "Person.h"
#import "SearchHistoryView.h"
#import <YYCache.h>
#import "Config.h"

@interface MySearchController ()<UISearchResultsUpdating, UISearchBarDelegate, UISearchControllerDelegate>

@property (nonatomic , strong) UISearchController *searchController;
@property (nonatomic , strong) SearchResultViewController *searchResultVC;
@property (nonatomic , strong) NSMutableArray *nameStringArray;
@property (nonatomic , strong) SearchHistoryView *historyView;
@property (nonatomic , strong) NSMutableArray *searchContentArray;   //存放搜索内容
@property (nonatomic , strong) YYCache *cache;

@end

@implementation MySearchController

+ (instancetype)defalutSearchController
{
    static MySearchController *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
        instance.searchResultVC = [[SearchResultViewController alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:instance.searchResultVC];
        instance.searchController = [[UISearchController alloc] initWithSearchResultsController:nav];
        instance.searchResultVC.searchBar = instance.searchController.searchBar;
        // 缓存
        instance.cache = [YYCache cacheWithName:cacheName];
    });
    return instance;
}

- (UISearchBar *)configSearchController
{
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    _searchController.delegate = self;
    _searchController.searchBar.placeholder = @"请输入搜索人姓名";
    _searchController.dimsBackgroundDuringPresentation = NO;
    // 点击搜索框时，是否隐藏 导航栏，默认是
//    _searchController.hidesNavigationBarDuringPresentation = NO;
    [_searchController.searchBar sizeToFit];
    return _searchController.searchBar;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSLog(@"%@", searchController.searchBar.text);
    [self.historyView removeFromSuperview];
    if (searchController.searchBar.text.length == 0) {
        [self.searchController.view addSubview:self.historyView];
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchController.searchBar.text];
    // 如果匹配，则返回所有匹配元素组成的数组
    NSArray *arr = [self.sourceArray filteredArrayUsingPredicate:predicate];

    self.searchResultVC.searchArrayList = arr;
    [self.searchResultVC.tableView reloadData];
    
//    for (int i = 0; i < self.nameStringArray.count; i++) {
//        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name CONTAINS[c] %@", searchController.searchBar.text];
//        if ([predicate evaluateWithObject:self.nameStringArray[i]]) {
//            NSLog(@"name === %@", [self.sourceArray[i] name]);
//        }
//    }
    
}

// 点击搜索按钮时
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchContent = self.searchController.searchBar.text;
    self.searchContentArray = (NSMutableArray *)[self.cache objectForKey:searchHistoryKey];
    [self.searchContentArray addObject:searchContent];
    // 缓存搜索历史数组
    [self.cache setObject:self.searchContentArray forKey:searchHistoryKey];
    self.historyView.historyArray = self.searchContentArray;
}

- (void)willPresentSearchController:(UISearchController *)searchController
{
    [self.searchController.view addSubview:self.historyView];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    [self.historyView removeFromSuperview];
}


- (void)setSourceArray:(NSArray *)sourceArray
{
    _sourceArray = sourceArray;
    [self getNameStringWithSourceArray:sourceArray];
}

// 获取姓名的拼音
- (void)getNameStringWithSourceArray:(NSArray *)array
{
    for (int i = 0; i < array.count; i++) {
        Person *p = array[i];
        if (p.name.length == 0) {
//            return [NSDictionary dictionary];
        }
        const char *c = [p.name UTF8String];
        CFStringRef str = CFStringCreateWithCString(NULL, c, kCFStringEncodingUTF8);
        CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, str);
        //一下两句是把汉字转换为不带声调的拼音，如只写 CFStringTransform(string, NULL, kCFStringTransformToLatin, false);  ，则会转化为带声调的拼音
        CFStringTransform(string, NULL, kCFStringTransformToLatin, false);
        CFStringTransform(string, NULL, kCFStringTransformStripCombiningMarks, false);
        // 转换成 NSString
        NSString *nString = (__bridge NSString *)(string);
        [self.nameStringArray addObject:nString];
    }
    
}

- (NSMutableArray *)nameStringArray
{
    if (!_nameStringArray) {
        _nameStringArray = [NSMutableArray array];
    }
    return _nameStringArray;
}


- (SearchHistoryView *)historyView
{
    if (!_historyView) {
        _historyView = [[SearchHistoryView alloc] initWithFrame:CGRectMake(0, 64, 375, 603)];
        __weak typeof(self) weakSelf = self;
        [_historyView setClickRowBlock:^(NSString *content) {
            weakSelf.searchController.searchBar.text = content;
        }];
    }
    return _historyView;
}

- (NSMutableArray *)searchContentArray
{
    if (!_searchContentArray) {
        _searchContentArray = [NSMutableArray array];
    }
    return _searchContentArray;
}

@end
