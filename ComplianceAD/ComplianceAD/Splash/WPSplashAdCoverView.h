//
//  WPSplashAdCoverView.h
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2021/6/11.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SpalshTipBtnType) {
    SplashNoShowBtnType = 0,//不显示按钮
    SplashAllClickType = 1,//显示按钮，全屏可点
    SplashBtnClickType = 2,//显示按钮，按钮可点
};

NS_ASSUME_NONNULL_BEGIN

@interface WPSplashAdCoverView : UIView

@property (nonatomic, assign) SpalshTipBtnType show_click_tip;


@end

NS_ASSUME_NONNULL_END
