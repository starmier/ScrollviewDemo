//
//  pageMgrView.m
//  ScrollviewDemo
//
//  Created by gdcn on 15-3-2.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "pageMgrView.h"

#define PAGE_MGR_PAGE_CTRL_HEIGHT   15

@implementation pageMgrView

@synthesize pageViews,currentIndex,width,height,pageCtrl,initialized,delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
          subViews:(NSArray *)views
      defaultIndex:(NSInteger)index
          delegate:(id)dele
    showPageCotrol:(BOOL)show{
    if (self = [self initWithFrame:frame]) {
        self.pageViews = [[NSMutableArray alloc]initWithArray:views];
        [self doInitWithFrame:frame subViews:self.pageViews defaultIndex:index delegate:dele showPageCotrol:show];
    }
    return self;
}

-(void)doInitWithFrame:(CGRect)frame
              subViews:(NSArray *)views
          defaultIndex:(NSInteger)index
              delegate:(id)dele
        showPageCotrol:(BOOL)show{
    if( initialized )
    {
        return;
    }
    
    if( !self.pageViews ){
        self.pageViews = [[NSMutableArray alloc] initWithArray:views];
    }
    width = frame.size.width;
    height = frame.size.height;
    
    self.delegate = dele;
    
    //设置当前显示的视图
    currentIndex = index;
    CGRect pageFrame = CGRectMake(0, 0, width, height);
    UIView *currentPage = [self.pageViews objectAtIndex:index];
    currentPage.frame = pageFrame;
    [self addSubview:currentPage];
    
    //设置前面视图（左侧视图），索引小于当前视图索引的视图
    CGFloat left = -width;
    for (NSInteger i = index - 1; i>=0; i--) {
        UIView *page = [self.pageViews objectAtIndex:i];
        page.clipsToBounds = YES;
        page.frame = CGRectMake(left, 0, width, height);
        [self addSubview:page];
        left -= width;
    }
    //设置后面视图（右侧视图），索引大于当前视图索引的视图
    left = width;
    for (NSInteger i = index + 1; i<self.pageViews.count; i++) {
        UIView *page = [self.pageViews objectAtIndex:i];
        page.clipsToBounds = YES;
        page.frame = CGRectMake(left, 0, width, height);
        [self addSubview:page];
        left += width;
    }
    
    
    //设置向右侧滑手势 及 触发事件
    UISwipeGestureRecognizer *rightSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    rightSwipeGR.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rightSwipeGR];
    //设置向左侧滑手势 及 触发事件
    UISwipeGestureRecognizer *leftSwipeGR = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeGestureAction:)];
    leftSwipeGR.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:leftSwipeGR];
    
    //设置控制按钮 UIPageControl
    CGRect pageCtrlFrame = CGRectMake(0, frame.size.height - PAGE_MGR_PAGE_CTRL_HEIGHT, frame.size.width, PAGE_MGR_PAGE_CTRL_HEIGHT);
    pageCtrl = [[UIPageControl alloc] initWithFrame:pageCtrlFrame];
    pageCtrl.numberOfPages = views.count;
    pageCtrl.currentPage = index;
    pageCtrl.backgroundColor = [UIColor clearColor];
    [self addSubview:pageCtrl];
    if( pageViews.count == 1 || !show )
    {
        pageCtrl.hidden = YES;
    }
    initialized = YES;
    
}
#pragma mark -- 滑动手势处理
-(void)swipeGestureAction:(UISwipeGestureRecognizer *)swipeGR{
    NSLog(@"--------------%s：%d",__func__,swipeGR.direction);
    
    if (swipeGR.direction == UISwipeGestureRecognizerDirectionRight) {
        [self rightSwipeGestureAction:swipeGR];
    }else if (swipeGR.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self leftSwipeGestureAction:swipeGR];
    }
}
//向右滑动
-(void)rightSwipeGestureAction:(UISwipeGestureRecognizer *)swipeGR{
    NSLog(@"--------------%s",__func__);
    
    
    //设置滑动的动画效果
    if (currentIndex && currentIndex > 0) {
        //获取前一个视图
        UIView *disPlayView = [pageViews objectAtIndex:currentIndex - 1];
        //获取当前视图
        UIView *dismissView = [pageViews objectAtIndex:currentIndex];
        
        //设置动画效果
        disPlayView.frame = CGRectMake(-width, 0, width, height);
        [UIView animateWithDuration:0.3 animations:^{
            
            disPlayView.frame = CGRectMake(0, 0, width, height);
            dismissView.frame = CGRectMake(width, 0, width, height);
            
        } completion:nil];
        
        
        //修改pageControl
        currentIndex --;
        pageCtrl.currentPage = currentIndex;
        if ([delegate respondsToSelector:@selector(didShowPage:atIndex:)]) {
            [delegate didShowPage:[pageViews objectAtIndex:currentIndex] atIndex:currentIndex];
        }
        
    }else if (currentIndex == 0){//尝试显示小于最小序号的页
        if ([delegate respondsToSelector:@selector(willOverLowbound)]) {
            [delegate willOverLowbound];
        }
    }
}
//向左滑动
-(void)leftSwipeGestureAction:(UISwipeGestureRecognizer *)swipeGR{
    NSLog(@"--------------%s",__func__);
    
    if (currentIndex < pageViews.count - 1 && currentIndex >= 0) {
        UIView *displayView = [pageViews objectAtIndex:currentIndex + 1];
        UIView *dismissView = [pageViews objectAtIndex:currentIndex];
        displayView.frame = CGRectMake(width, 0, width, height);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            displayView.frame = CGRectMake(0, 0, width, height);
            dismissView.frame = CGRectMake(-width, 0, width, height);
            
        } completion:nil];
        
        
        //修改pageControl
        currentIndex ++;
        pageCtrl.currentPage = currentIndex;
        if ([delegate respondsToSelector:@selector(didShowPage:atIndex:)]) {
            [delegate didShowPage:[pageViews objectAtIndex:currentIndex] atIndex:currentIndex];
        }
        
    }else if (currentIndex == pageViews.count - 1){//尝试显示大于最大序号的页
        if ([delegate respondsToSelector:@selector(willOverUpbound)]) {
            [delegate willOverUpbound];
        }
    }
}

-(void)showSubView:(NSInteger)index{
    if (currentIndex == index) {
        return;
    }
    
    NSInteger diff = index - currentIndex;
    if (diff > 0) {//右滑
        for (UIView *v in pageViews) {
            CGRect frame = v.frame;
            frame.origin.x -= self.frame.size.width;
            v.frame = frame;
        }
    }else if(diff < 0){//左滑
        for (UIView *v in pageViews) {
            CGRect frame = v.frame;
            frame.origin.x += self.frame.size.width;
            v.frame = frame;
        }
    }
    
    currentIndex = index;
    pageCtrl.currentPage = currentIndex;
    
    //通过代理 通知界面滑动已完成
    if ([delegate respondsToSelector:@selector(didShowPage:atIndex:)]) {
        [delegate didShowPage:[pageViews objectAtIndex:currentIndex] atIndex:currentIndex];
    }
    
}

-(void)dealloc{
    [pageViews removeAllObjects];
    NSLog(@"--------------%s",__func__);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
