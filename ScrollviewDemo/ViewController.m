//
//  ViewController.m
//  ScrollviewDemo
//
//  Created by gdcn on 15-3-2.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "ViewController.h"
#import "TestView.h"
//#import "pageMgrView.h"
#import "pageMgrExtView.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat yPoint = 0.0f;
    CGRect rect = [UIScreen mainScreen].bounds;
    if ([UIDevice currentDevice].systemVersion.floatValue > 6.0) {
        yPoint += 20.0f;
    }
    rect.size.height -= 20;
    
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, yPoint, rect.size.width, 30)];
    label.text = @"可滑动视图，并且带动画效果";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:label];
    
    yPoint += 30;
    
    CGRect pageMgrRect = CGRectMake(0, yPoint, rect.size.width , rect.size.height);
    
    CGRect pageRect = CGRectMake(0, 0, rect.size.width , rect.size.height);

  
    NSInteger maxNum = 10;
    NSMutableArray *pages = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (NSInteger num = 0; num < maxNum; num++) {
        
        TestView *page = [[TestView alloc]initWithFrame:pageRect data:nil pageIndex:num];
        
        [pages addObject:page];
    }
    
    
    pageMgrExtView *pageMgr = [[pageMgrExtView alloc]initWithFrame:pageMgrRect subViews:pages defaultIndex:0 delegate:self showPageCotrol:YES];
    [self.view addSubview:pageMgr];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
