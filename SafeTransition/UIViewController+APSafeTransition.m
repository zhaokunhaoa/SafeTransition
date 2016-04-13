//
//  UINavigationController+Consistent.h
//  RunTime
//
//  Created by hanamichi on 16/1/4.
//  Copyright © 2016年 hanamichi. All rights reserved.
//

#import "UIViewController+APSafeTransition.h"
#import "UINavigationController+APSafeTransition.h"
#import <objc/runtime.h>

@implementation UIViewController (APSafeTransition)

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
