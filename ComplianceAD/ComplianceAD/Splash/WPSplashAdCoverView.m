//
//  WPSplashAdCoverView.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2021/6/11.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import "WPSplashAdCoverView.h"

@interface WPSplashAdCoverView()

@property(nonatomic, strong) UIView *jumpView;

@end


@implementation WPSplashAdCoverView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGRect frame = CGRectMake(self.frame.size.width/2.0-150, self.frame.size.height-65, 300, 50);

        CGFloat fontSize = 17;
        if (self.frame.size.width < 375) {
            frame = CGRectMake(self.frame.size.width/2.0-140, self.frame.size.height-61, 280, 46);
            fontSize = 15;
        }
        self.jumpView = [[UIView alloc] initWithFrame:frame];
        self.jumpView.layer.cornerRadius = self.jumpView.frame.size.height/2.0;
        self.jumpView.layer.backgroundColor = [UIColor colorWithRed:(0)/255.0f green:(0)/255.0f blue:(0)/255.0f alpha:0.6].CGColor;
        self.jumpView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.jumpView.layer.borderWidth = 1.0;
        CGFloat imageSize = fontSize;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.jumpView.frame.size.width-imageSize-20, self.jumpView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:fontSize weight:(UIFontWeightRegular)];
        label.textColor = [UIColor whiteColor];
        label.text = @"点击跳转详情页面或到第三方应用";
        label.textAlignment = NSTextAlignmentCenter;
        [self.jumpView addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"show_click_tip_icon"]];
        [self.jumpView addSubview:imageView];
        imageView.frame = CGRectMake(label.frame.origin.x + label.frame.size.width, self.jumpView.frame.size.height/2.0-imageSize/2.0, imageSize, imageSize);
        
        [self addSubview:self.jumpView];
    }
    return self;
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if (![self pointInside:point withEvent:event]){
            return nil;
    }
    if (self.show_click_tip == SplashBtnClickType) {
            //显示按钮，按钮可点
        CGPoint childP = [self convertPoint:point toView:self.jumpView];
        if ([self.jumpView pointInside:childP withEvent:event]) {
            return nil;
        }else{
            return self;
        }
    }else if (self.show_click_tip == SplashAllClickType) {
        //显示按钮，全屏可点
        return nil;
    }else{
        return nil;
    }
}

@end
