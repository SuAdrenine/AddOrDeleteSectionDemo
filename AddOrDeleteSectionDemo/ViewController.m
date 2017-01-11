//
//  ViewController.m
//  AddOrDeleteSectionDemo
//
//  Created by xby on 2017/1/9.
//  Copyright © 2017年 xby. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, copy) NSMutableArray *titleArr;
@property(nonatomic, copy) NSMutableArray *dataArr;
@property(nonatomic, copy) NSMutableDictionary *flagDic;
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.dataArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [NSString stringWithFormat:@"%ld",section];
    
    if (section == 1) {
        return 0;
    }
    
    
    if ([[self.flagDic valueForKey:key] isEqualToString:@"1"]) {
        return [self.dataArr[section] count];
    } else {
        return 0;
    }
}

static NSString *reuseIdentifier = @"reuseIdentifier";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = self.dataArr[indexPath.section][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

// 在返回头视图的方法里面给每个区添加一个button
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [UIView new];
    UILabel *label = [UILabel new];
    // 把分区的头视图设置成Button
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    
    [bgView addSubview:label];
    [bgView addSubview:button];
    bgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    label.text = [NSString stringWithFormat:@"Section%ld:%@",section,self.titleArr[section]];
    
    // 设置Button的标题作为section的标题用
    [button setImage:[UIImage imageNamed:@"main_arrow_down"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"main_arrow_right"] forState:UIControlStateSelected];
    // 设置点击事件
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchDown)];
    // 给定tag值用于确定点击的对象是哪个区
    button.tag = section + 1000;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView).offset(10);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView).offset(-10);
        make.centerY.equalTo(bgView);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    return bgView;
}

// 设置Button的点击事件
- (void)buttonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    NSInteger temp = sender.tag - 1000;
    NSString *sectionNumStr = [NSString stringWithFormat:@"%ld",temp];
    
    if (temp == 1){ //节点为1
        if([[self.flagDic valueForKey:sectionNumStr] isEqualToString:@"1"]) {    //当点击了节点1且需要收缩时，需要做删除节点2的操作
            //            [self.flagDic removeObjectForKey:[NSString stringWithFormat:@"%ld",(temp+1)]];
            [self.flagDic removeObjectForKey:[NSString stringWithFormat:@"%d",3]];
            
            [self.flagDic setObject:@"0" forKey:sectionNumStr];
            
            [self.dataArr removeObjectAtIndex:2];
            [self.titleArr removeObjectAtIndex:2];
            
            [self.tableView reloadData];
//            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:(temp+1)] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView endUpdates];
        }else{
            //            [self.flagDic setObject:@"1" forKey:[NSString stringWithFormat:@"%ld",(temp+1)]];
            [self.flagDic removeObjectForKey:[NSString stringWithFormat:@"%d",3]];
            
            [self.flagDic setObject:@"1" forKey:sectionNumStr];
            
            [self.dataArr insertObject:@[@"加拿大",@"美国",@"墨西哥"] atIndex:2];
            [self.titleArr insertObject:@"美洲" atIndex:2];
            
            [self.tableView reloadData];
//            [self.tableView beginUpdates];
//            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:(temp+1)] withRowAnimation:UITableViewRowAnimationAutomatic];
//            [self.tableView endUpdates];
            
        }
    } else {
        // 修改 每个区的收缩状态  因为每次点击后对应的状态改变 temp代表是哪个section
        if ([[self.flagDic valueForKey:sectionNumStr] isEqualToString:@"0"] ) {
            
            [self.flagDic setObject:@"1" forKey:sectionNumStr];
        }else {
            
            [self.flagDic setObject:@"0" forKey:sectionNumStr];
        }
        
        [self.tableView beginUpdates];
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:temp] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    
    // 更新 section
    //    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:temp] withRowAnimation:(UITableViewRowAnimationFade)];
    
    
}

#pragma mark - getter & setter
-(NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = @[@[@"中国",@"越南",@"巴基斯坦"],@[@"英国",@"法国",@"德国",@"意大利"],@[@"加拿大",@"美国",@"墨西哥"],@[@"埃及",@"刚果"]].mutableCopy;
    }
    
    return _dataArr;
}

-(NSMutableArray *)titleArr{
    if (!_titleArr) {
        _titleArr = @[@"亚洲",@"欧洲",@"美洲",@"非洲"].mutableCopy;
    }
    
    return _titleArr;
}

-(NSMutableDictionary *)flagDic {
    if (!_flagDic) {
        _flagDic = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                   @"0":@"1",
                                                                   @"1":@"1",
                                                                   @"2":@"1",
                                                                   @"3":@"1"
                                                                   }];
    }
    
    return _flagDic;
}

-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.frame = CGRectMake(0, 70, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        
        //        _tableView.sectionHeaderHeight = 0.1;
        _tableView.sectionFooterHeight = 0.1;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        
        //        [_tableView registerClass:[MySectionHeaderView class] forHeaderFooterViewReuseIdentifier:@"MySectionHeaderView"];
    }
    
    return _tableView;
    
}
@end
