//
//  GDTUnifiedTemplateView+DDSwizz.m
//  RingtoneDuoduo
//
//  Created by 唐天成 on 2021/7/18.
//  Copyright © 2021 duoduo. All rights reserved.
//

#import "NSObject+DDSwizz.h"
#import <objc/runtime.h>

@implementation NSObject (DDSwizz)

- (void)setDdisShowToastTip:(BOOL)ddisShowToastTip {
    objc_setAssociatedObject(self, @selector(ddisShowToastTip), @(ddisShowToastTip), OBJC_ASSOCIATION_ASSIGN);

}

- (BOOL)ddisShowToastTip {
    BOOL b = [objc_getAssociatedObject(self, _cmd) boolValue];
    return b;
}

//+ (void)DDswizzMethod {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class class = NSClassFromString(@"GDTUnifiedTemplateView");
//        SEL originalSelector = @selector(click:);
//        SEL swizzledSelector = @selector(swiz_click:);
//        Method originalMethod = class_getInstanceMethod(class, originalSelector);
//        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//        if(!originalMethod) {
//            return;
//        }
//        BOOL didAddMethod = class_addMethod(class,
//                                            originalSelector,
//                                            method_getImplementation(swizzledMethod),
//                                            method_getTypeEncoding(swizzledMethod));
//        if (didAddMethod) {
//            class_replaceMethod(class,
//                                swizzledSelector,
//                                method_getImplementation(originalMethod),
//                                method_getTypeEncoding(originalMethod));
//        } else {
//            method_exchangeImplementations(originalMethod, swizzledMethod);
//        }
//    });
//}

//#pragma mark - Method Swizzling
//- (void)swiz_click:(id)btn
//{
//    //插入需要执行的代码
////    DLog(@"我在viewWillAppear执行前偷偷插入了一段代码");
//    //不能干扰原来的代码流程，插入代码结束后要让本来该执行的代码继续执行
////    [self topLevelWindowGet];
//    if(self.ddisShowToastTip) {
//        [GetAppDelegate().window showToast:@"即将跳转详情页面或第三方应用" autoHideTime:1.3 offset:CGPointMake(0, (ScreenHeight - 58)/2 - (kDevice_Is_iPhoneX ? 34 : 0) - 30)];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self swiz_click:btn];
//
//        });
//    } else {
//        [self swiz_click:btn];
//
//    }
//   
//}

@end
