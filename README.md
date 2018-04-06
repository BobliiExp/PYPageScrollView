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
    * 自动轮播
    * 更多页面提示
    * 展示页数可配置
    * 切换过度效果
    * frame布局支持
    * swift支持

## 实现方案
    * 已知问题
      1.直接将所有页面加载到scrollview上内存消耗极大
      2.控制多个页面交互逻辑代码繁琐，会增加主viewcontroller代码量，不利于业务流程编写
      3.遇到内存警告不清楚哪些页面或数据缓存应该清理，不方便管理
      
## 特点

## 如何使用

## 扩展
