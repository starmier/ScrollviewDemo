//
//  pageMgrView.h
//  ScrollviewDemo
//
//  Created by gdcn on 15-3-2.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 页视图管理类协议
 */
@protocol pageMgrViewDelegate <NSObject>

@optional

/**
 已经显示某一个页
 @page: 已显示的页对象
 @index: 序号
 */
-(void)didShowPage:(id)page atIndex:(NSInteger)index;

/**
 尝试显示大于最大序号的页
 */
- (void)willOverUpbound;

/**
 尝试显示小于最小序号的页
 */
- (void)willOverLowbound;

@end



/**
 具有左右滑动切换子视图的视图类
 */
@interface pageMgrView : UIView
/**
 * 当前页序号
 */
@property NSInteger currentIndex;

/**
 * 宽度
 */
@property CGFloat width;


/**
 *  高度
 */
@property CGFloat height;

/**
 *  页控件对象
 */
@property UIPageControl *pageCtrl;


/**
 *  是否已经初始化
 */
@property BOOL initialized;

/**
 *  页数组
 */
@property NSMutableArray *pageViews;

/**
 *  委托
 */
@property (weak)id<pageMgrViewDelegate> delegate;


/**
 @param frame 该视图在父视图中的区域
 @param views 子视图列表，UIView成员
 @param index 默认显示的子视图
 @param dele 符合pageMgrViewDelegate的对象
 */
- (id)initWithFrame:(CGRect)frame
           subViews:(NSArray*)views
       defaultIndex:(NSInteger)index
           delegate:(id)dele
     showPageCotrol:(BOOL)show;

/**
 *  初始化
 *
 *  @param frame 该视图在父视图中的区域
 *  @param views 子视图列表，UIView成员
 *  @param index 默认显示的子视图
 *  @param dele  符合pageMgrViewDelegate的对象
 *  @param show  是否显示页控件
 */
- (void)doInitWithFrame:(CGRect)frame
               subViews:(NSArray*)views
           defaultIndex:(NSInteger)index
               delegate:(id)dele
         showPageCotrol:(BOOL)show;
/**
 * 向右滑动
 */
-(void)rightSwipeGestureAction:(UISwipeGestureRecognizer *)swipeGR;
/**
 * 向左滑动
 */
-(void)leftSwipeGestureAction:(UISwipeGestureRecognizer *)swipeGR;
/**
 *  显示某一子视图
 *
 *  @param index 子视图序号
 */
- (void)showSubView:(NSInteger)index;

@end
