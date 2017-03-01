//
//  SearchResultViewController.m
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//  

#import "SearchResultViewController.h"
#import "Person.h"
#import "DetailViewController.h"

@interface SearchResultViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation SearchResultViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchBar.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.searchBar.alpha = 1.0;
    }];
}

//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    self.searchBar.hidden = NO;
//    [UIView animateWithDuration:0.2 animations:^{
//        self.searchBar.alpha = 1.0;
//    }];
//}

- (void)viewWillDisappear:(BOOL)animated
{ 
    [super viewWillDisappear:animated];
    [self hiddenSearchBar];
    [self.searchBar endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    [self tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArrayList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    Person *p = self.searchArrayList[indexPath.row];
    cell.textLabel.text = p.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Person *p = self.searchArrayList[indexPath.row];
    DetailViewController *detailVC = [[DetailViewController alloc] init];
    detailVC.title = [NSString stringWithFormat:@"%@, %@, %d", p.name, p.gender, p.age];
    [self.navigationController pushViewController:detailVC animated:YES];
}

// 隐藏导航栏
- (void)hiddenSearchBar
{
    [self.searchBar setHidden:YES];
    self.searchBar.alpha = 0;
}


- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -45, self.view.frame.size.width, self.view.frame.size.height + 45) style:UITableViewStylePlain];
        _tableView.rowHeight = 50;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}


@end
