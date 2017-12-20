//
//  MYSelectIndexVC.m
//  XinShengInternational
//
//  Created by michelle on 2017/10/17.
//  Copyright © 2017年 michelle. All rights reserved.
//

#import "MYSelectIndexVC.h"

@interface MYSelectIndexVC ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *mainIndexCollView;  //主指标图collectionView
@property (weak, nonatomic) IBOutlet UICollectionView *plotIndexCollView;  //副指标图collectionView
@property (weak, nonatomic) IBOutlet UISegmentedControl *setHiddenSegC;    //是否隐藏副指标图的SegmentedControl
@property (nonatomic, retain) NSMutableArray *mainIndexAry;                //主指标图名称array
@property (nonatomic, retain) NSMutableArray *plotIndexAry;                //副指标图名称array
@end

@implementation MYSelectIndexVC

#pragma mark ================== 懒加载 =================

/**
 主指标图名称array

 @return 主指标图名称array
 */
- (NSMutableArray *)mainIndexAry {
    if (!_mainIndexAry) {
        _mainIndexAry = [@[@"BBI",@"BOLL",@"MA",@"MIKE",@"PBX"] mutableCopy];
    }
    return _mainIndexAry;
}



/**
 副指标图名称array

 @return 副指标图名称array
 */
- (NSMutableArray *)plotIndexAry {
    if (!_plotIndexAry) {
        _plotIndexAry = [@[@"ARBR",@"ATR",@"BIAS",@"CCI",@"DKBY",@"KD",@"KDJ",@"LW&R",@"MACD",@"QHLSR",@"RSI",@"W&R"] mutableCopy];
    }
    return _plotIndexAry;
}


#pragma mark ================== viewDidLoad =================
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [[HexColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.2];
    [self setupCollectionView];
    if (MYKLineVC.shareMYKLineVC.hiddenPlotIndex) {
        self.setHiddenSegC.selectedSegmentIndex = 0;
    } else {
        self.setHiddenSegC.selectedSegmentIndex = 1;
    }
}

- (void)setupCollectionView{
    self.mainIndexCollView.scrollEnabled = NO;
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 5, self.mainIndexCollView.frame.size.height);
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    self.mainIndexCollView.collectionViewLayout = flowLayout;
    
    self.plotIndexCollView.scrollEnabled = NO;
    UICollectionViewFlowLayout *plotflowLayout = [[UICollectionViewFlowLayout alloc] init];
    plotflowLayout.itemSize = CGSizeMake(SCREEN_WIDTH / 5, self.mainIndexCollView.frame.size.height);
    plotflowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    plotflowLayout.minimumInteritemSpacing = 0;
    plotflowLayout.minimumLineSpacing = 0;
    self.plotIndexCollView.collectionViewLayout = plotflowLayout;
}


#pragma mark ================== StoryBoard Action =================

/**
 隐藏显示副指标图

 @param sender 隐藏显示副指标图
 */
- (IBAction)setHiddenSegAction:(UISegmentedControl *)sender {
    if ((MYKLineVC.shareMYKLineVC.hiddenPlotIndex == YES && sender.selectedSegmentIndex == 1) || (MYKLineVC.shareMYKLineVC.hiddenPlotIndex == NO && sender.selectedSegmentIndex == 0)) {
        MYKLineVC.shareMYKLineVC.hiddenPlotIndex = !MYKLineVC.shareMYKLineVC.hiddenPlotIndex;
        self.updataKLine();
    }
}


/**
 关闭

 @param sender 关闭
 */
- (IBAction)closeAction:(UIButton *)sender {
    self.closeAction();
}


#pragma mark ================== ColltionView Delegate =================
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 900001) {
        return self.mainIndexAry.count;
    } else {
        return self.plotIndexAry.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 900001) {
        
        BaseCollectionViewCell *cell = [FactoryCollectionViewCell createCollctionViewWithID:@"MainIndex_Item" collectionView:collectionView indexPath:indexPath];
        NSString *str = self.mainIndexAry[indexPath.row];
        [cell setDataWithSourceData:str indexPath:indexPath];
        
        if ([str isEqualToString:MYKLineVC.shareMYKLineVC.mainIndexName]) {
            cell.contentView.backgroundColor = [UIColor grayColor];
        } else {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    } else {
        BaseCollectionViewCell *cell = [FactoryCollectionViewCell createCollctionViewWithID:@"PlotIndex_Item" collectionView:collectionView indexPath:indexPath];
        NSString *str = self.plotIndexAry[indexPath.row];
        [cell setDataWithSourceData:str indexPath:indexPath];
        if ([str isEqualToString:MYKLineVC.shareMYKLineVC.plotIndexName]) {
            cell.contentView.backgroundColor = [UIColor grayColor];
        } else {
            cell.contentView.backgroundColor = [UIColor whiteColor];
        }
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 900001) {
        if (![MYKLineVC.shareMYKLineVC.mainIndexName isEqualToString: self.mainIndexAry[indexPath.row]]) {
            MYKLineVC.shareMYKLineVC.mainIndexName = self.mainIndexAry[indexPath.row];
            [self.mainIndexCollView reloadData];
            self.updataKLine();
        }
        
    } else {
        if (![MYKLineVC.shareMYKLineVC.plotIndexName isEqualToString: self.plotIndexAry[indexPath.row]]) {
            MYKLineVC.shareMYKLineVC.plotIndexName = self.plotIndexAry[indexPath.row];
            [self.plotIndexCollView reloadData];
            self.updataKLine();
        }
    }
    
}
@end
