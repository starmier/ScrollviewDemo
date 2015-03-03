//
//  pageMgrExtView.m
//  ScrollviewDemo
//
//  Created by gdcn on 15-3-2.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "pageMgrExtView.h"

#define DEFAULT_M34     -1.0/500// 透视效果
#define STEP1_DURATION  0.5
#define STEP2_DURATION  0.5

@implementation pageMgrExtView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

#pragma mark -- 重写父类方法
-(void)doInitWithFrame:(CGRect)frame
              subViews:(NSArray *)views
          defaultIndex:(NSInteger)index
              delegate:(id)dele
        showPageCotrol:(BOOL)show{

    if( self.initialized )
    {
        return;
    }
    self.width = frame.size.width;
    self.height = frame.size.height;
    
//    [self.pageViews removeAllObjects];
//    [self.pageViews addObjectsFromArray:views];
    
    self.delegate = dele;
    self.currentIndex = index;
    CGRect pageFrame = CGRectMake(0, 0, self.width, self.height);
    UIView *currentPage = [self.pageViews objectAtIndex:index];
    currentPage.frame = pageFrame;
    [self addSubview:currentPage];
    
    CGFloat left = -self.width;
    for( NSInteger i = index - 1; i >= 0; i-- )
    {
        UIView *page = [self.pageViews objectAtIndex:i];
        page.frame = CGRectMake(left, 0, self.width, self.height);
        [self addSubview:page];
        left -=self.width;
    }
    left = self.width;
    for( NSInteger i = index + 1; i < self.pageViews.count; i++ )
    {
        UIView *page = [self.pageViews objectAtIndex:i];
        page.frame = CGRectMake(left, 0, self.width, self.height);
        [self addSubview:page];
        left += self.width;
    }
    UISwipeGestureRecognizer *rsgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipeGestureAction:)];
    rsgr.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer:rsgr];
    
    UISwipeGestureRecognizer *lsgr = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipeGestureAction:)];
    lsgr.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer:lsgr];
    
    CGRect pageCtrlFrame = CGRectMake(0, frame.size.height - 37, frame.size.width, 37);
    self.pageCtrl = [[UIPageControl alloc] initWithFrame:pageCtrlFrame];
    self.pageCtrl.numberOfPages = views.count;
    self.pageCtrl.currentPage = index;
    self.pageCtrl.backgroundColor = [UIColor clearColor];
    [self.pageCtrl addTarget:self action:@selector(onTouchupPageControl:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.pageCtrl];
    
    
    if( self.pageViews.count == 1 || !show )
    {
        self.pageCtrl.hidden = YES;
    }
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0/500;
    self.layer.sublayerTransform = transform;
    
    
    self.initialized = YES;
}

- (void)onTouchupPageControl:(id)sender
{
    UIPageControl *pc = (UIPageControl*)sender;
    if (pc.currentPage == self.currentIndex) {
        return;
    }
    
    if (pc.currentPage < self.currentIndex) {
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] init];
        recognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self rightSwipeGestureAction:recognizer];
    }else
    {
        UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc] init];
        recognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self leftSwipeGestureAction:recognizer];
    }
}
-(void)rightSwipeGestureAction:(UISwipeGestureRecognizer *)swipeGR{
    if (self.currentIndex > 0 && self.currentIndex) {
        
        //设置将要出现视图 的动画效果
        UIView *displayView = [self.pageViews objectAtIndex:self.currentIndex - 1];
        __block CATransform3D displayTransform = CATransform3DIdentity;
        displayTransform.m34 = DEFAULT_M34;
        displayTransform = CATransform3DScale(displayTransform, 0.1, 0.1, 0.1);//设置缩放比例
        displayTransform = CATransform3DRotate(displayTransform, M_PI, 0, 1, 0);//后面三个数字 反别代表以不同的轴进行翻转，这里设置以y轴为旋转轴
        //设置动画效果
        displayView.frame = CGRectMake(-self.width, 0, self.width, self.height);
        displayView.layer.anchorPoint = CGPointMake(0.5, 0.5);//设置翻转时的中心点，0.5为试图layer的正中
        displayView.layer.transform = displayTransform;
        displayView.layer.shouldRasterize = YES;
        
        
        
        //设置当前消失视图 的动画效果
        UIView *dismissView = [self.pageViews objectAtIndex:self.currentIndex];
        __block CATransform3D dismissTransform = CATransform3DIdentity;
        dismissTransform.m34 = DEFAULT_M34;
        dismissTransform = CATransform3DScale(dismissTransform, 0.7, 0.7, 0.7);
        dismissView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        dismissView.layer.transform = dismissTransform;
        dismissView.layer.shouldRasterize = YES;
        
        //这里必须设置，修改上一步动画效果产生的二进制图片
         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
         [UIView animateWithDuration:STEP1_DURATION animations:^(){
             
             displayView.frame = CGRectMake(0, 0, self.width, self.height);
             displayTransform = CATransform3DScale(displayTransform, 5, 5, 5);//在原来的transfrom基础上缩放
             displayTransform = CATransform3DRotate(displayTransform, -1 * 5 * M_PI / 6, 0, 1, 0);
             displayView.layer.transform = displayTransform;
            
                 
             dismissView.frame = CGRectMake(self.width, 0, self.width, self.height);
             dismissTransform = CATransform3DRotate(dismissTransform, -M_PI, 0, 1, 0);
             dismissTransform = CATransform3DScale(dismissTransform, 0.1, 0.1, 0.1);
             dismissView.layer.transform = dismissTransform;
             dismissView.layer.shouldRasterize = NO;
             
         }completion:^(BOOL finished){
             [UIView animateWithDuration:STEP2_DURATION animations:^(){
                
                    //使得 显示视图，恢复正常，界面平行放置
                    displayView.layer.transform = CATransform3DIdentity;
                    displayView.layer.shouldRasterize = NO;
                }];
         }];
        

        self.currentIndex--;
        self.pageCtrl.currentPage = self.currentIndex;
        if( [self.delegate respondsToSelector:@selector(didShowPage:atIndex:)] )
        {
            [self.delegate didShowPage:displayView atIndex:self.currentIndex];
        }
    }else if( self.currentIndex == 0 )
    {
        if( [self.delegate respondsToSelector:@selector(willOverLowbound)] )
        {
            [self.delegate willOverLowbound];
        }
    }
}
-(void)leftSwipeGestureAction:(UISwipeGestureRecognizer *)swipeGR{
    if( self.currentIndex < self.pageViews.count - 1 && self.currentIndex >= 0 )
    {
        UIView *displayView = [self.pageViews objectAtIndex:self.currentIndex + 1];//frame = (0 0; 320 460)
        displayView.frame = CGRectMake(self.width, 0, self.width, self.height);
        displayView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        __block CATransform3D displayTransform = CATransform3DIdentity;
        displayTransform.m32 = DEFAULT_M34;
        displayTransform = CATransform3DRotate(displayTransform, -M_PI, 0, 1, 0);
        displayTransform = CATransform3DScale(displayTransform, 0.1, 0.1, 0.1);
        displayView.layer.transform = displayTransform;
        displayView.layer.shouldRasterize = YES;//frame = (464 207; 32 46)
        
        UIView *dismissView = [self.pageViews objectAtIndex:self.currentIndex];
        __block CATransform3D dismissTransform = CATransform3DIdentity;
        dismissTransform.m34 = DEFAULT_M34;
        dismissTransform = CATransform3DScale(dismissTransform, 0.7, 0.7, 0.7);
        dismissView.layer.anchorPoint = CGPointMake(0.5, 0.5);
        dismissView.layer.transform = dismissTransform;
        dismissView.layer.shouldRasterize = YES;
        
        
        //这里必须设置，修改上一步动画效果产生的二进制图片
        [UIView animateWithDuration:0.5 animations:^(){
            displayView.frame = CGRectMake(0, 0, self.width, self.height);
            displayTransform = CATransform3DRotate(displayTransform, 5*M_PI/6, 0, 1, 0);
            displayTransform = CATransform3DScale(displayTransform, 5, 5, 5);
            displayView.layer.transform = displayTransform;//rame = (90.718 114.92; 138.564 230.16)
            
            dismissView.frame = CGRectMake(-self.width, 0, self.width, self.height);
            dismissTransform = CATransform3DRotate(dismissTransform, M_PI/2, 0, 1, 0);
            dismissTransform = CATransform3DScale(dismissTransform, 0.1, 0.1, 0.1);
            dismissView.layer.transform = dismissTransform;
            dismissView.layer.shouldRasterize = NO;
        } completion:^(BOOL finished){
            if( finished )
            {
                [UIView animateWithDuration:0.5 animations:^(){
                    displayView.layer.transform = CATransform3DIdentity;//frame = (0 0; 320 460)
                } completion:^(BOOL finished){
                    if( finished )
                    {
                        //去掉栅格化点阵化效果
                        displayView.layer.shouldRasterize = NO;
                    }
                }];
            }
        }];
        
        
        self.currentIndex++;
        self.pageCtrl.currentPage = self.currentIndex;
        if( [self.delegate respondsToSelector:@selector(didShowPage:atIndex:)] )
        {
            [self.delegate didShowPage:displayView atIndex:self.currentIndex];
        }
    }
    else if( self.currentIndex == self.pageViews.count - 1 )
    {
        if( [self.delegate respondsToSelector:@selector(willOverUpbound)] )
        {
            [self.delegate willOverUpbound];
        }
    }

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
