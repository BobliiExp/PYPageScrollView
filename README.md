PYPageScrollView
===========================
本自定义控件，主要为可左右滑动切换页面或者轮播内容功能提供页面交互管理与缓存方案，demo参考[PYHero](https://github.com/BobliiExp/PYHero)。
重用页面支持UIViewController、UIView，并且采用AutoLayout布局

****
	
|Author|YG45|
|---|---
|E-mail|Bobliihotmailcom

****
## 目录
* [实现方案](#实现方案)
    * 已知问题
    * 解决思路
    * 实现办法
* [特点](#特点)
    * 内存
    * 交互体验
* [如何使用](#如何使用)
    * 如何使用
    * 交互体验
* [扩展](#扩展)

## 实现方案
![](/PYPageScrollView/Resource/image.png)

	* 已知问题
	1.直接将所有页面加载到scrollview上内存消耗极大
	2.控制多个页面交互逻辑代码繁琐，会增加主viewcontroller代码量，不利于业务流程编写
	3.遇到内存警告不清楚哪些页面或数据缓存应该清理，不方便管理
	
	* 解决思路
	根据交互使用情况，需要确保当前页面左右页面已加载就能满足滑动展示内容连续性；
	同时在内部对已加载页面进行缓存分页逻辑支持，降低耦合；
	通过已加载数据与当前页的距离，判断是否清理，支持低内存模式，清理重用几率低的缓存数据或页面；
	增加过度效果提高交互体验
	
	* 实现办法
	PYPageScrollView继承于UIScrollView，内部实现分页管理，页面缓存管理，页面切换动画，以及相关页面变化的委托通知外部处理者；
	
	
## 特点
	通过自定义ScrollView将分页操作业务单独封装降低程序耦合，提高复用性；
	页面移动出可见界面后再一定时间没有存在的意义，合理进行释放控制，可以减少内存消耗
	支持UIView，UIViewController作为页面内容

## 如何使用
  工程需要引入pod库
```c
pod 'Masonry'
```
  需要使用的地方添加引用，并且实现相关委托协议
```c
#import "PYPageScrollView.h"
```
```c
@interface ViewController () <PYPageScrollViewDataSource>
// 根据需求，选择以下任意一个重用方法
- (UIViewController *)pageScrollView:(PYPageScrollView *)pageScrollView viewControllerForPage:(NSInteger)index;
- (UIView *)pageScrollView:(PYPageScrollView *)pageScrollView viewForPage:(NSInteger)index;
```
如果自己的page有支持内存释放控制（清理相关引用关系方法），可以实现此委托方法关心页面清理情况
```c
- (void)pageScrollViewWillCleanView:(PYPageScrollView*)pageScrollView view:(UIView*)view; 
- (void)pageScrollViewWillCleanViewController:(PYPageScrollView*)pageScrollView vc:(UIViewController*)vc;
```

## 扩展
    * 自动轮播
    
    * 更多页面提示
    * 展示页数可配置
    * 切换过度效果
    * frame布局支持
    * swift支持
