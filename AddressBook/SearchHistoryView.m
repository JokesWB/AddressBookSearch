//
//  SearchHistoryView.m
//  AddressBook
//
//  Created by admin on 2017/2/21.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import "SearchHistoryView.h"
#import <YYCache.h>
#import "Config.h"

@interface SearchHistoryView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , strong) UIButton *clearBtn;
@property (nonatomic , strong) YYCache *cache;


@end

@implementation SearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 取出缓存数组
        self.cache = [YYCache cacheWithName:cacheName];
        self.historyArray = (NSMutableArray *)[self.cache objectForKey:searchHistoryKey];
        
        
        
    }
    return self;
}

- (void)setHistoryArray:(NSMutableArray *)historyArray
{
    _historyArray = historyArray;
    self.tableView.tableFooterView = self.historyArray.count == 0 ? [UIView new] : self.clearBtn;
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.historyArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.historyArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了 == %@", self.historyArray[indexPath.row]);
    if (self.clickRowBlock) {
        self.clickRowBlock(self.historyArray[indexPath.row]);
    }
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"搜索历史";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // 从数组里删除
        [self.historyArray removeObjectAtIndex:indexPath.row];
        // 因为缓存的是数组，所以先要删除所有缓存，再重新进行缓存
        [self.cache removeObjectForKey:searchHistoryKey];          // 删除所有缓存
        // 重新缓存删除后的数组
        [self.cache setObject:self.historyArray forKey:searchHistoryKey];
        self.tableView.tableFooterView = self.historyArray.count == 0 ? [UIView new] : self.clearBtn;
        [self.tableView reloadData];
    }
}



- (void)clearSearchHistory
{
    //清空搜索记录
    [self.cache removeObjectForKey:searchHistoryKey];
    [self.historyArray removeAllObjects];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView reloadData];
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        [self addSubview:_tableView];
        
    }
    return _tableView;
}

- (UIButton *)clearBtn
{
    if (!_clearBtn) {
        _clearBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        _clearBtn.frame = CGRectMake(0, 0, 100, 30);
        [_clearBtn setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        [_clearBtn addTarget:self action:@selector(clearSearchHistory) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clearBtn;
}

@end
