//
//  BUNativeExpressAdView+MyTestt.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2021/7/16.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import "BUNativeExpressAdView+DDSwizz.h"
#import "NSObject+DDSwizz.h"
#import "MBProgressHUD.h"
#import <objc/runtime.h>

@implementation BUNativeExpressAdView (DDSwizz)

//- (void)setIsShowToastTip:(BOOL)isShowToastTip {
//    objc_setAssociatedObject(self, @selector(isShowToastTip), @(isShowToastTip), OBJC_ASSOCIATION_ASSIGN);
//
//}
//
//- (BOOL)isShowToastTip {
//    BOOL b = [objc_getAssociatedObject(self, _cmd) boolValue];
//    return b;
//}

+ (void)DDswizzMethod {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = @selector(handleClickEventIsVideoClicked:isEndcardClicked:);
        SEL swizzledSelector = @selector(swiz_handleClickEventIsVideoClicked:isEndcardClicked:);
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        if(!originalMethod) {
            return;
        }
        BOOL didAddMethod = class_addMethod(class,
                                            originalSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling
- (void)swiz_handleClickEventIsVideoClicked:(BOOL)isVideoClicked isEndcardClicked:(BOOL)isEndcardClicked
{
    //插入需要执行的代码
//    DLog(@"执行前偷偷插入了一段代码");
    //不能干扰原来的代码流程，插入代码结束后要让本来该执行的代码继续执行
//    [self topLevelWindowGet];
    if(self.ddisShowToastTip) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].delegate.window animated:YES];
        // Set the text mode to show only text.
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"即将跳转详情页面或第三方应用";
        // Move to bottm center.
        hud.offset = CGPointMake(0, ([UIScreen mainScreen].bounds.size.height - 58)/2 - 64);
        [hud hideAnimated:YES afterDelay:1.3f];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self swiz_handleClickEventIsVideoClicked:isVideoClicked isEndcardClicked:isVideoClicked];

        });
    } else {
        [self swiz_handleClickEventIsVideoClicked:isVideoClicked isEndcardClicked:isVideoClicked];

    }
   
}

//-(UIWindow *)topLevelWindowGet
//
//{
//    DLog(@"%@",[UIApplication sharedApplication].windows);
//    UIWindow *topView = [UIApplication sharedApplication].keyWindow;
//
//    for (UIWindow *win in [[UIApplication sharedApplication].windows  reverseObjectEnumerator]) {
//
//        if ([win isEqual: topView]) {
//
//            continue;
//
//        }
//
//        if (win.windowLevel > topView.windowLevel && win.hidden != YES ) {
//
//            topView =win;
//
//        }
//
//    }
//
//    return topView;
//
//}



@end
