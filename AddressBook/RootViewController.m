//
//  RootViewController.m
//  AddressBook
//
//  Created by admin on 2017/2/18.
//  Copyright © 2017年 LaiCunBa. All rights reserved.
//

#import "RootViewController.h"
#import "Person.h"
#import "AddressBookTool.h"
#import "MySearchController.h"

@interface RootViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray *personsArray;
@property (nonatomic , strong) NSArray *dataArray;
@property (nonatomic , strong) NSArray *sectionIndexArray;
@property (nonatomic , strong) UITableView *tableView;


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"通讯录";
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchAction)];
    
    [self addFirends];
    
    [self tableView];

}

- (void)addFirends
{
    [self creatPerson];
    
    AddressBookTool *tool = [AddressBookTool new];
    [tool needHandleArray:self.personsArray getFinalArray:^(NSArray *finalArray, NSArray *sectionIndexArray) {
        self.dataArray = finalArray;
        self.sectionIndexArray = sectionIndexArray;
        NSLog(@"最终 ==== %@", finalArray);
    }];
}

- (void)creatPerson
{
    Person *p1 = [Person setName:@"张三" Age:23 Gender:@"男"];
    Person *p2 = [Person setName:@"李四" Age:24 Gender:@"女"];
    Person *p3 = [Person setName:@"王五" Age:25 Gender:@"男"];
    Person *p4 = [Person setName:@"赵六" Age:26 Gender:@"女"];
    Person *p5 = [Person setName:@"张达" Age:27 Gender:@"男"];
    Person *p6 = [Person setName:@"薛七" Age:28 Gender:@"男"];
    Person *p7 = [Person setName:@"王八" Age:21 Gender:@"男"];
    Person *p8 = [Person setName:@"小九" Age:20 Gender:@"女"];
    Person *p9 = [Person setName:@"李潇潇" Age:29 Gender:@"女"];
    Person *p10 = [Person setName:@"历史" Age:90 Gender:@"男"];
    Person *p11 = [Person setName:@"章章" Age:45 Gender:@"女"];
    Person *p12 = [Person setName:@"123" Age:80 Gender:@"女"];
    Person *p13 = [Person setName:@"冰冰" Age:23 Gender:@"女"];
    [self.personsArray addObject:p1];
    [self.personsArray addObject:p2];
    [self.personsArray addObject:p3];
    [self.personsArray addObject:p4];
    [self.personsArray addObject:p5];
    [self.personsArray addObject:p6];
    [self.personsArray addObject:p7];
    [self.personsArray addObject:p8];
    [self.personsArray addObject:p9];
    [self.personsArray addObject:p10];
    [self.personsArray addObject:p11];
    [self.personsArray addObject:p12];
    [self.personsArray addObject:p13];
    
    [MySearchController defalutSearchController].sourceArray = self.personsArray;
}

// 创建搜索框
- (void)searchAction
{
    self.tableView.tableHeaderView = [[MySearchController defalutSearchController] configSearchController];
//    self.navigationItem.titleView = [[MySearchController defalutSearchController] configSearchController];
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataArray[section];
    NSArray *array = [dic objectForKey:dic.allKeys.firstObject];
    return array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *array = [dic objectForKey:dic.allKeys.firstObject];
    Person *p = array[indexPath.row];
    
    cell.textLabel.text = p.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *array = [dic objectForKey:dic.allKeys.firstObject];
    Person *p = array[indexPath.row];
    
    NSLog(@"点击了  %@", p.name);
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataArray[section];
    return dic.allKeys.firstObject;
}

// 返回索引数组
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.sectionIndexArray;
}

#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

#pragma mark - 懒加载
- (NSMutableArray *)personsArray
{
    if (!_personsArray) {
        _personsArray = [NSMutableArray array];
    }
    return _personsArray;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 50;
        // 设置索引字体颜色
        _tableView.sectionIndexColor = [UIColor redColor];
        _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
        _tableView.sectionIndexTrackingBackgroundColor = [UIColor clearColor];
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
