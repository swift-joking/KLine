//
//  MYSetIndexVC.m
//  XinShengInternational
//
//  Created by michelle on 2017/9/25.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYSetIndexVC.h"
#import "SetIndexDetailCell.h"

@interface MYSetIndexVC () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *IndexTabView;     //指标名称TableView
@property (weak, nonatomic) IBOutlet UITableView *SetIndexTabView;  //指标参数TableView
@property (nonatomic, assign) NSInteger selectIndex;                //当前选中的指标的下标
@end

@implementation MYSetIndexVC

#pragma mark ================== viewDidLoad =================
- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark ==================  =================
/**
 进入该view时选择的指标的名称
 
 @param index 指标名称
 */
- (void)setIndex:(NSString *)index {
    for (int i = 0; i < [MYKLineVC shareMYKLineVC].mainIndexAry.count; i++) {
        NSString *name = [MYKLineVC shareMYKLineVC].mainIndexAry[i];
        if ([name isEqualToString:index]) {
            self.selectIndex = i;
//            self.selectStr = name;
            break;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.SetIndexTabView reloadData];
    });
}

#pragma mark ================== StoryBoard Action =================

/**
 保存修改参数

 @param sender 保存修改参数
 */
- (IBAction)saveIndexAction:(id)sender {
    NSArray *array = [MYKLineVC shareMYKLineVC].plotIndexAry[self.selectIndex];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dic = array[i][0];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:i inSection:0];
        SetIndexDetailCell *cell = (SetIndexDetailCell *)[self.SetIndexTabView cellForRowAtIndexPath:indexpath];
        if ((int)dic[@"newValue"] == -1) {
            [dic setValue:[NSNumber numberWithInteger:[cell.detailTextField.text integerValue]] forKey:@"newValue"];
            self.setIndex([MYKLineVC shareMYKLineVC].mainIndexAry[self.selectIndex]);
        } else {
            NSLog(@"text = %d",[cell.detailTextField.text intValue]);
            NSLog(@"text = %d",[[dic objectForKey:@"value"] intValue]);
            if ([cell.detailTextField.text intValue] != [[dic objectForKey:@"value"] intValue]) {
                [dic setValue:[NSNumber numberWithInteger:[cell.detailTextField.text integerValue]] forKey:@"newValue"];
                self.setIndex([MYKLineVC shareMYKLineVC].mainIndexAry[self.selectIndex]);
            }
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.SetIndexTabView reloadData];
    });
    
}


/**
 恢复默认参数

 @param sender 恢复默认参数
 */
- (IBAction)restoreDefaultAction:(id)sender {
    NSArray *array = [MYKLineVC shareMYKLineVC].plotIndexAry[self.selectIndex];
    for (int i = 0; i < array.count; i++) {
        NSMutableDictionary *dic = array[i][0];
        [dic setValue:@(-1) forKey:@"newValue"];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.SetIndexTabView reloadData];
    });
    self.setIndex([MYKLineVC shareMYKLineVC].mainIndexAry[self.selectIndex]);
}


#pragma mark ================== TableView Delegate =================
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 800001) {
        return [MYKLineVC shareMYKLineVC].mainIndexAry.count;
    } else {
        NSArray *array = [MYKLineVC shareMYKLineVC].plotIndexAry[self.selectIndex];
        return array.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell;
    if (tableView.tag == 800001) {
        cell = [FactoryTableViewCell createTableViewCellWithID:@"SetIndexList_Cell" tableView:tableView indexPath:indexPath];
        NSString *name = [MYKLineVC shareMYKLineVC].mainIndexAry[indexPath.row];
        [cell setDataWithSourceData:name];
        if (indexPath.row == self.selectIndex) {
            cell.contentView.backgroundColor = [UIColor grayColor];
        } else {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
    } else {
        cell = [FactoryTableViewCell createTableViewCellWithID:@"SetIndexDetail_Cell" tableView:tableView indexPath:indexPath];
        NSArray *array = [MYKLineVC shareMYKLineVC].plotIndexAry[self.selectIndex];
        [cell setDataWithSourceData:array[indexPath.row]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

// 点击之后的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 800001) {
        self.selectIndex = indexPath.row;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.IndexTabView reloadData];
            [self.SetIndexTabView reloadData];
        });
    }
}



@end
