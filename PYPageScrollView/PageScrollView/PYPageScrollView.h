//
//  PYPageScrollView.h
//  PYHero
//
//  Created by Bob Lee on 2018/4/1.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PYPageScrollView;

@protocol PYPageScrollViewDataSource <NSObject>

@required
- (NSInteger)numberOfPage:(PYPageScrollView *)pageScrollView;

@optional
- (UIView *)pageScrollView:(PYPageScrollView *)pageScrollView viewForPage:(NSInteger)index;
- (UIViewController *)pageScrollView:(PYPageScrollView *)pageScrollView viewControllerForPage:(NSInteger)index;

- (void)pageScrollViewDidScroll:(PYPageScrollView *)pageScrollView;
- (void)pageScrollViewDidEndDragging:(PYPageScrollView *)pageScrollView willDecelerate:(BOOL)decelerate;
- (void)pageScrollViewDidEndDecelerating:(PYPageScrollView*)pageScrollView;
- (void)pageScrollViewWillBeginDragging:(PYPageScrollView*)pageScrollView;

- (void)pageScrollView:(PYPageScrollView*)pageScrollView willChangeToIndex:(NSInteger)pageIndex;
- (void)pageScrollView:(PYPageScrollView*)pageScrollView didChangeToIndex:(NSInteger)pageIndex;

/// 清理对应页面，只有在reload时出发
- (void)pageScrollViewWillCleanView:(PYPageScrollView*)pageScrollView view:(UIView*)view;
- (void)pageScrollViewWillCleanViewController:(PYPageScrollView*)pageScrollView vc:(UIViewController*)vc;

@end

@interface PYPageScrollView : UIScrollView<UIScrollViewDelegate>

@property (nonatomic, weak) id<PYPageScrollViewDataSource> datasource;  ///< 必须设置操作委托
@property (nonatomic, readonly) NSInteger numberOfPage;   ///< 当前页面总数
@property (nonatomic, readonly) NSInteger currentPage;    ///< 当前显示页码
@property (nonatomic, assign) BOOL lowMemoryEnable;   ///< 是否保持低内存占用，默认NO-只要是不同class的页面都会保持在内存中，交互体验会更佳；YES-内存中只缓存可见页面与备用页面，滑动或切换会重新加载，交互体验较差

/**
 * @brief 内存缓存页码列表
 * @return [UIView]
 */
- (NSArray*)visiblePages;

/**
 * @brief 页码缓存重用检查
 * @param className 重用标识
 * @return UIView 如果有缓存返回缓存
 */
- (UIView*)dequeueReusableViewWithClassName:(Class)className;

- (UIViewController*)dequeueReusableViewControllerWithClassName:(Class)className;

/**
 * @brief 跳转到指定页面
 * @param index 页码
 */
- (void)jumpPageToIndex:(NSInteger)index;

/**
 * @brief 重新加载所有页面（数据源发生变化）
 */
- (void)reloadData;

/**
 * @brief 重新加载当前页面（仅当前页面数据变化需要刷新）
 */
- (void)reloadCurrentData;

/**
 * @brief 重新加载指定页面
 */
- (void)reloadDataAtIndex:(NSInteger)index;

/**
 * @brief 清理内存数据以及相关引用关系，确保可以及时释放内存
 */
- (void)cleanSelf;

/**
 * @brief 在遇到内存警告时，可以清理当前页面+上下页面外的页面
 */
- (void)cleanCache;

@end
