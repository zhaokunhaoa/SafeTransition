//
//  UINavigationController+APSafeTransition.h
//
//  Created by hanamichi on 16/1/4.
//  Copyright © 2016年 hanamichi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (APSafeTransition)

@property(readwrite,getter = isViewTransitionInProgress) BOOL viewTransitionInProgress;

@end

@interface UIViewController (APSafeTransitionLock)

@end
