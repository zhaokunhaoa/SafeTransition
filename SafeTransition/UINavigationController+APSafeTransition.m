//
//  UINavigationController+APSafeTransition.h
//
//  Created by hanamichi on 16/1/4.
//  Copyright © 2016年 hanamichi. All rights reserved.
//

#import "UINavigationController+APSafeTransition.h"
#import <objc/runtime.h>

static char const * const ObjectTagKey = "ObjectTag";

@interface UINavigationController () <UINavigationControllerDelegate>

@end

@implementation UINavigationController (APSafeTransition)

+ (void)load {
    
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(pushViewController:animated:)),
                                   class_getInstanceMethod(self,@selector(safePushViewController:animated:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(popViewControllerAnimated:)),
                                   class_getInstanceMethod(self,@selector(safePopViewControllerAnimated:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(popToRootViewControllerAnimated:)),
                                   class_getInstanceMethod(self,@selector(safePopToRootViewControllerAnimated:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self,@selector(popToViewController:animated:)),
                                   class_getInstanceMethod(self,@selector(safePopToViewController:animated:)));
    
}

#pragma mark - setter & getter
- (void)setViewTransitionInProgress:(BOOL)property {
    
    NSNumber *number = [NSNumber numberWithBool:property];
    
    objc_setAssociatedObject(self,ObjectTagKey, number , OBJC_ASSOCIATION_RETAIN);
    
}

- (BOOL)isViewTransitionInProgress {
    
    NSNumber *number =objc_getAssociatedObject(self, ObjectTagKey);
    
    return[number boolValue];
}

#pragma mark - Intercept Pop, Push, PopToRootVC
- (NSArray*)safePopToRootViewControllerAnimated:(BOOL)animated {
    
    if(self.viewTransitionInProgress) return nil;
    
    if (animated) {
        
        self.viewTransitionInProgress =YES;
    }
    
    NSArray *viewControllers = [self safePopToRootViewControllerAnimated:animated];
    
    if (viewControllers.count == 0) {
        
        self.viewTransitionInProgress = NO;
    }
    
    return viewControllers;
}

- (NSArray*)safePopToViewController:(UIViewController*)viewController animated:(BOOL)animated {
    
    if(self.viewTransitionInProgress) return nil;
    
    if(animated){
        
        self.viewTransitionInProgress =YES;
    }
    
    NSArray *viewControllers = [self safePopToViewController:viewController animated:animated];
    
    if (viewControllers.count == 0) {
        
        self.viewTransitionInProgress = NO;
    }
    
    return viewControllers;
}

- (UIViewController*)safePopViewControllerAnimated:(BOOL)animated {
    
    if (self.viewTransitionInProgress) return nil;
    
    if (animated) {
        
        self.viewTransitionInProgress =YES;
    }
    
    UIViewController *viewController = [self safePopViewControllerAnimated:animated];
    
    if (viewController == nil) {
        
        self.viewTransitionInProgress = NO;
    }
    
    return viewController;
}

- (void)safePushViewController:(UIViewController*)viewController animated:(BOOL)animated {
    
    if (self.isViewTransitionInProgress == NO) {
        
        [self safePushViewController:viewController animated:animated];
        
        if (animated) {
            
            self.viewTransitionInProgress = YES;
        }
    }
}

@end

@implementation UIViewController (APSafeTransitionLock)

+ (void)load {
    
    Method m1;
    Method m2;
    
    m1 = class_getInstanceMethod(self, @selector(sofaViewDidAppear:));
    m2 = class_getInstanceMethod(self, @selector(viewDidAppear:));
    
    method_exchangeImplementations(m1, m2);
}

- (void)sofaViewDidAppear:(BOOL)animated {
    
    self.navigationController.viewTransitionInProgress = NO;
    
    [self sofaViewDidAppear:animated];
}

@end
