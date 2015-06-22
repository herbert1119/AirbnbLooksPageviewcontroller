//
//  ViewController.h
//  AirbnbPageViewController
//
//  Created by Bo Han on 2015-06-18.
//  Copyright © 2015 Bo Han. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContentViewController.h"
@interface ViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic) UIPageViewController *pageViewController;

@property (nonatomic) NSArray *pageTexts;
@property (nonatomic) NSArray *pageImages;
@property (nonatomic) NSArray *buttonColors;

@end

