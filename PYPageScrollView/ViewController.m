//
//  ViewController.m
//  PYPageScrollView
//
//  Created by Bob Lee on 2018/4/6.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "ViewController.h"
#import "PYPageScrollView.h"

#import "PYVCPage.h"

@interface ViewController () <PYPageScrollViewDataSource>

@property (weak, nonatomic) IBOutlet PYPageScrollView *pageView;

@property (nonatomic, copy) NSArray *arrData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self setupData];
}

- (void)setupUI {
    self.pageView.datasource = self;
}

- (void)setupData {
    self.arrData = @[@"PYVCPage",
                     @"PYVCPage",
                     @"PYVCPage",
                     @"PYVCPage",
                     @"PYVCPage",
                     @"PYVCPage"
                     ];
    
    [self.pageView reloadData];
}

#pragma mark PYPageScrollViewDataSource

- (NSInteger)numberOfPage:(PYPageScrollView *)pageScrollView {
    return self.arrData.count;
}

// 自定义view时使用
//- (UIView *)pageScrollView:(PYPageScrollView *)pageScrollView viewForPage:(NSInteger)index {
//
//}

- (UIViewController *)pageScrollView:(PYPageScrollView *)pageScrollView viewControllerForPage:(NSInteger)index {
    Class cls = NSClassFromString(self.arrData[index]);
    UIViewController *vc = [pageScrollView dequeueReusableViewControllerWithClassName:cls];
    if(vc==nil){
        vc = [[PYVCPage alloc] initWithNibName:@"PYVCPage" bundle:[NSBundle mainBundle]];
        [vc loadView];
    }
    
    // 这里根据vc类型可以考虑跟新数据展示
    if([vc isKindOfClass:[PYVCPage class]]){
        [(PYVCPage*)vc updateDesc:[NSString stringWithFormat:@"Page %ti", index]];
    }
    
    return vc;
}

- (void)pageScrollViewDidScroll:(PYPageScrollView *)pageScrollView {
    
}

- (void)pageScrollViewDidEndDragging:(PYPageScrollView *)pageScrollView willDecelerate:(BOOL)decelerate {
    
}

- (void)pageScrollViewDidEndDecelerating:(PYPageScrollView*)pageScrollView {
    
}

- (void)pageScrollViewWillBeginDragging:(PYPageScrollView*)pageScrollView {
    
}

- (void)pageScrollView:(PYPageScrollView*)pageScrollView willChangeToIndex:(NSInteger)pageIndex {
    
}

- (void)pageScrollView:(PYPageScrollView*)pageScrollView didChangeToIndex:(NSInteger)pageIndex {
    
}

/// 清理对应页面，只有在reload时出发
//- (void)pageScrollViewWillCleanView:(PYPageScrollView*)pageScrollView view:(UIView*)view {
//
//}

- (void)pageScrollViewWillCleanViewController:(PYPageScrollView*)pageScrollView vc:(UIViewController*)vc {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
