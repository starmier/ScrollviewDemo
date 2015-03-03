//
//  TestView.m
//  ScrollviewDemo
//
//  Created by gdcn on 15-3-2.
//  Copyright (c) 2015年 cndatacom. All rights reserved.
//

#import "TestView.h"

@implementation TestView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame
              data:(id)data
         pageIndex:(NSInteger)index{
    if (self = [self initWithFrame:frame]) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:frame];
        label.text = [NSString stringWithFormat:@"page--%d--",index];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:30];
        [self addSubview:label];
        
//        self.backgroundColor = [UIColor colorWithRed:225/(index+1) green:225/(index+1) blue:225/(index+1) alpha:1];
        switch (index) {
            case 0:
                self.backgroundColor = [UIColor redColor];
                break;
            case 1:
                self.backgroundColor = [UIColor yellowColor];
                break;
            case 3:
                self.backgroundColor = [UIColor redColor];
                break;
            default:
                self.backgroundColor = [UIColor greenColor];
              
                break;
        }
        
    }
    return self;
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
