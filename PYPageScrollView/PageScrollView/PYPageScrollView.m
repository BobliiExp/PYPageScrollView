//
//  PYPageScrollView.m
//  PYHero
//
//  Created by Bob Lee on 2018/4/1.
//  Copyright © 2018年 Bob Lee. All rights reserved.
//

#import "PYPageScrollView.h"
#import "Masonry.h"

@interface PYPageScrollView ()

@property (nonatomic, strong) NSMutableArray *mArrViews;    ///< 缓存的页面
@property (nonatomic, assign) NSInteger currentManagePage;  ///< 当前正在加载的界面
@property (nonatomic, weak) UIView *viewContainer;   ///< 容器
@property (nonatomic, weak) UIView *viewFlag;   ///< 滚动标签

@end

@implementation PYPageScrollView

#pragma mark - 初始化

- (instancetype)init {
    self = [super init];
    if(self){
        [self initDefault];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initDefault];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self){
        [self initDefault];
    }
    
    return self;
}

- (void)initDefault {
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.pagingEnabled = YES;
    self.delegate = self;
//    self.backgroundColor = [UIColor whiteColor]; // 不设置主要是为了排除适配问题
}

- (NSMutableArray*)mArrViews {
    if(_mArrViews==nil){
        _mArrViews = [NSMutableArray array];
    }
    
    return _mArrViews;
}

- (UIView*)dequeueReusableViewWithClassName:(Class)className {
    UIView *target = nil;
    UIView *reuse = nil;
    for (UIView *subview in self.mArrViews) {
        if([subview isKindOfClass:className]){
            if (subview.tag == 1000+self.currentManagePage) {
                reuse = subview;
                break;
            }
            
            // 找不到对应界面，将可现实页面外的页面重用起来;这里可以控制重用缓存页码数量
            if (target==nil && labs(subview.tag - 1000 - self.currentPage) >= 2) {
                target = subview;
            }
        }
    }
    
    return reuse?reuse:target;
}

- (UIViewController*)dequeueReusableViewControllerWithClassName:(Class)className {
    UIViewController *target = nil;
    UIViewController *reuse = nil;
    for (UIViewController *vc in self.mArrViews) {
        if([vc isKindOfClass:className]){
            if (vc.view.tag == 1000+self.currentManagePage) {
                reuse = vc;
                break;
            }
            
            // 找不到对应界面，将可现实页面外的页面重用起来;这里可以控制重用缓存页码数量
            if (target==nil && labs(vc.view.tag - 1000 - self.currentPage) >= 2) {
                target = vc;
            }
        }
    }
    
    return reuse?reuse:target;
}

- (UIView*)pageWithPageIndex:(NSInteger)index {
    if(index<0)return nil;
    
    for (NSObject *temp in self.mArrViews) {
        UIView *view = [temp isKindOfClass:[UIViewController class]] ? ((UIViewController*)temp).view : (UIView*)temp;
        if(view.tag == 1000+index){
            return view;
        }
    }
    
    return nil;
}

- (UIView*)pageWithCacheIndex:(NSInteger)index {
    NSObject *temp = [self.mArrViews objectAtIndex:index];
    return [temp isKindOfClass:[UIViewController class]] ? ((UIViewController*)temp).view : (UIView*)temp;
}

// 首次绘制时异步出发页面加载
//- (void)drawRect:(CGRect)rect {
//    [self reloadData];
//}

- (void)resetSubview:(NSInteger)index {
    //如果超出范围不做处理
    if (index<0 || index>=self.numberOfPage) {
        return;
    }
    
    if(index==self.currentPage){
        if([self.datasource respondsToSelector:@selector(pageScrollView:willChangeToIndex:)])
            [self.datasource pageScrollView:self willChangeToIndex:index];
    }
    
    self.currentManagePage = index;
    
    UIView *page = nil;
    UIViewController *vc = nil;
    if([self.datasource respondsToSelector:@selector(pageScrollView:viewForPage:)]){
        page = [self.datasource pageScrollView:self viewForPage:index];
    }else if([self.datasource respondsToSelector:@selector(pageScrollView:viewControllerForPage:)]){
        vc = [self.datasource pageScrollView:self viewControllerForPage:index];
        page = vc.view;
    }
    
    page.tag = 1000+index;
    
    //移除scrollView里面与当前需要添加的view有相同tag的view；注意这个view可能非重用情况
    for (int i = 0; i < self.mArrViews.count; ) {
        UIView *view = [self pageWithCacheIndex:i];
        if (view.tag == 1000 + index) {
            [view removeFromSuperview];
            
            if(![view isEqual:page]){
                // 未被重用的页面移除队列后需要清理内存
                [self cleanPage:vc?vc:page];
            }
            
            [self.mArrViews removeObjectAtIndex:i];
        } else {
            i ++;
        }
    }

    //如果未添加
    if (![self.mArrViews containsObject:vc?vc:page] && page) {
        if(self.viewContainer==nil){
            UIView *view = [[UIView alloc] init];
            [self addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self);
                make.height.equalTo(self);
            }];
            self.viewContainer = view;
        }
        
        [self.viewContainer addSubview:page];
        [self.mArrViews addObject:vc?vc:page];
        
        [page mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.and.bottom.equalTo(self.viewContainer);
            make.width.equalTo(self);
            make.left.equalTo(self.viewContainer).mas_offset(CGRectGetWidth(self.frame)*index);
        }];
    }
    
    if(index==self.currentPage){
        if([self.datasource respondsToSelector:@selector(pageScrollView:didChangeToIndex:)])
            [self.datasource pageScrollView:self didChangeToIndex:index];
    }
}

- (void)reloadData {
    _numberOfPage = [self.datasource numberOfPage:self];
    
    if (self.currentPage>=self.numberOfPage) {
        self.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*(self.numberOfPage-1), 0);
        _currentPage = self.numberOfPage-1; // 策略可选择，如果刷新数据源后页面减少了，继续显示最后一页
    }
    
    // 数据可能已经变化了，需要全部清理重新加载
//    for (NSObject *temp in self.mArrViews) {
//        [self cleanPage:temp];
//    }
//
//    [self.mArrViews removeAllObjects];
    
    if(self.numberOfPage>0){
        for(NSInteger i=-1; i<2; i++){
            [self resetSubview:self.currentPage+i];
        }
    }
    
    if(self.lowMemoryEnable){
        [self cleanCache];
    }
    
    if(self.viewFlag==nil){
        UIView *view = [[UIView alloc] init];
        view.hidden = YES;
        [self.viewContainer addSubview:view];
        self.viewFlag = view;
    }
    
    [self.viewFlag mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.viewContainer);
        CGFloat offset = CGRectGetWidth(self.frame)*(self.numberOfPage);
        make.left.equalTo(self.viewContainer).offset(offset);
    }];
    
    [self.viewContainer mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.viewFlag);
    }];
}

- (void)cleanPage:(NSObject*)temp {
    if([temp isKindOfClass:[UIViewController class]]){
        UIViewController *vc = (UIViewController*)temp;
        if([self.datasource respondsToSelector:@selector(pageScrollViewWillCleanViewController:vc:)]){
            [self.datasource pageScrollViewWillCleanViewController:self vc:vc];
        }
        
        [vc.view removeFromSuperview];
    }else {
        if([self.datasource respondsToSelector:@selector(pageScrollViewWillCleanView:view:)]){
            [self.datasource pageScrollViewWillCleanView:self view:(UIView*)temp];
        }
        
        [((UIView*)temp) removeFromSuperview];
    }
}

- (void)reloadCurrentData {
    [self resetSubview:self.currentPage];
}

- (void)reloadDataAtIndex:(NSInteger)index {
    [self resetSubview:index];
}

- (NSArray*)visiblePages {
    return [self.mArrViews copy];
}

- (void)cleanSelf {
    if(self.mArrViews){
        [self.mArrViews removeAllObjects];
        self.mArrViews = nil;
    }
    
    self.datasource = nil;
}

- (void)cleanCache {
    // 清理当前显示页面+左右页面以外的页面
    for (int i = 0; i < self.mArrViews.count;) {
        NSObject *temp = self.mArrViews[i];
        UIView *view = [temp isKindOfClass:[UIViewController class]] ? ((UIViewController*)temp).view : (UIView*)temp;
        if(view.tag != 1000+self.currentPage &&
           view.tag != 1000+self.currentPage-1 &&
           view.tag != 1000+self.currentPage+1){
            [self cleanPage:temp];
            [self.mArrViews removeObjectAtIndex:i];
        }else {
            i++;
        }
    }
}

#pragma mark - setter

- (void)jumpPageToIndex:(NSInteger)index {
    _currentPage = index;
    
    self.contentOffset = CGPointMake(CGRectGetWidth(self.frame)*_currentPage, 0);
    // 设置显示界面，可能跳过来当前位置界面还未初始化
    [self reloadData];
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.datasource respondsToSelector:@selector(pageScrollViewDidScroll:)]) {
        [self.datasource pageScrollViewDidScroll:self];
    }
    
    [self pageScrollend];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.datasource respondsToSelector:@selector(pageScrollViewDidEndDragging:willDecelerate:)]) {
        [self.datasource pageScrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.datasource respondsToSelector:@selector(pageScrollViewDidEndDecelerating:)]) {
        [self.datasource pageScrollViewDidEndDecelerating:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.datasource respondsToSelector:@selector(pageScrollViewWillBeginDragging:)]) {
        [self.datasource pageScrollViewWillBeginDragging:self];
    }
}

- (void)pageScrollend {
    if(self.numberOfPage<=1)return;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat offset = self.contentOffset.x;
    
    NSInteger page = offset/width;
    CGFloat pageFloat = offset/width;
    if (fabs(pageFloat-page)>0.5) {
        page ++;
    }
    
    if (page != self.currentPage) {
        NSInteger dValue = page-self.currentPage;
        if([self.datasource respondsToSelector:@selector(pageScrollView:willChangeToIndex:)])
            [self.datasource pageScrollView:self willChangeToIndex:page];
        
        _currentPage = page;
        [self resetSubview:page+dValue];
        
        if(self.lowMemoryEnable){
            [self cleanCache];
        }
        
        if([self.datasource respondsToSelector:@selector(pageScrollView:didChangeToIndex:)])
            [self.datasource pageScrollView:self didChangeToIndex:page];
    }
}

@end
