//
//  ViewController.m
//  AirbnbPageViewController
//
//  Created by Bo Han on 2015-06-18.
//  Copyright © 2015 Bo Han. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (nonatomic) CALayer *imageLayer;
@property (nonatomic) CALayer *imageLayer2;
@property (nonatomic) NSUInteger currentPageIndex;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // predefined values
    // tests display on each page
    self.pageTexts = @[@"Welcome travelers from around the world to your neighborhood.",
                       @"Earn money by sharing your extra space or entire home.",
                       @"With trusted profiles and tools, you decide who stays and when to host.",
                       @"Join a community of passionate hosts and enjoy 24-hour support."];
    
    // images display on each page
    self.pageImages = @[@"page1.jpg",
                        @"page2.jpg",
                        @"page3.jpg",
                        @"page4.jpg"];
    
    // button colors for each page
    self.buttonColors = @[[UIColor colorWithRed:249.0/255.0 green:197.0/255.0 blue:55.0/255.0 alpha:1.0],
                          [UIColor colorWithRed:234.0/255.0 green:108.0/255.0 blue:91.0/255.0 alpha:1.0],
                          [UIColor colorWithRed:247.0/255.0 green:218.0/255.0 blue:109.0/255.0 alpha:1.0],
                          [UIColor colorWithRed:25.0/255.0 green:167.0/255.0 blue:134.0/255.0 alpha:1.0]];
    
    self.button.backgroundColor = (UIColor *)self.buttonColors[0];
    
    //create first layer
    self.imageLayer = [CALayer layer];
    self.imageLayer.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height-46);
    self.imageLayer.contents =(__bridge id __nullable)([UIImage imageNamed:self.pageImages[0]].CGImage);
    self.imageLayer.contentsGravity = kCAGravityResizeAspectFill;

    //create second layer
    self.imageLayer2 = [CALayer layer];
    self.imageLayer2.frame = self.imageLayer.frame;
    self.imageLayer2.opacity = 0;
    self.imageLayer2.contentsGravity = kCAGravityResizeAspectFill;
    
    //create dim layer for easy to read text with white color
    CALayer *dimLayer = [CALayer layer];
    dimLayer.frame = self.imageLayer.frame;
    dimLayer.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2].CGColor;
    
    [self.view.layer addSublayer:self.imageLayer];
    [self.view.layer addSublayer:self.imageLayer2];
    [self.view.layer addSublayer:dimLayer];
    
    // page view controller configuration
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PageViewController"];
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    PageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:NO
                                     completion:nil];
    
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    
    // page indicator configuration
    self.pageControl.numberOfPages = [self.pageTexts count];
    
    // make views visible to bring views to front
    [self.view bringSubviewToFront:self.pageControl];
    [self.view bringSubviewToFront:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if ([self.pageTexts count]==0 || index >= [self.pageTexts count]) {
        return nil;
    }
    
    PageContentViewController *pageContent = [self.storyboard instantiateViewControllerWithIdentifier:@"PageContentViewController"];
    
    pageContent.text = self.pageTexts[index];
    pageContent.pageIndex = index;
    return pageContent;
}

- (CABasicAnimation *)fadeInEffectForLayers:(BOOL)fadeIn{
    
    // set values for fade in
    NSNumber *fromValue = @(0);
    NSNumber *toValue = @(1);
    
    if (!fadeIn) {
        fromValue = @(1);
        toValue = @(0);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = fromValue;
    animation.toValue = toValue;
    animation.duration = 0.5;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    return animation;
}

- (void)overlapAnimationFadeInLayer1:(CALayer *)layer1 FadeOutlayer2:(CALayer *)layer2
{
    CABasicAnimation *fadeInAnimation = [self fadeInEffectForLayers:YES];
    CABasicAnimation *fadeOutAnimation = [self fadeInEffectForLayers:NO];
    [layer1 addAnimation:fadeInAnimation forKey:nil];
    [layer2 addAnimation:fadeOutAnimation forKey:nil];
}

#pragma mark - Page View Controller Delegate
- (void)pageViewController:(nonnull UIPageViewController *)pageViewController willTransitionToViewControllers:(nonnull NSArray<UIViewController *> *)pendingViewControllers
{
    NSUInteger pageIndex =((PageContentViewController *)(pendingViewControllers.firstObject)).pageIndex;
    self.currentPageIndex = pageIndex;
}

- (void)pageViewController:(nonnull UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(nonnull NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (!completed) { // do nothing if transition isn't completed.
        return;
    }
    
    // update and refresh page indicator
    // current page index is updated when transition start
    // look at the function above
    self.pageControl.currentPage = self.currentPageIndex;
    
    UIImage *currentImage = [UIImage imageNamed:(NSString *)self.pageImages[self.currentPageIndex]];
    
    // this part is for animation, the animation is using two layers for doing overlap fade in and out effect.
    // one layer need to fade in and the other layer need to fade out
    // the first page use one layer then the other page use the second layer and so on
    if (self.currentPageIndex % 2 == 0) {
        
        self.imageLayer.contents = (__bridge id __nullable)(currentImage.CGImage);
        [self overlapAnimationFadeInLayer1:self.imageLayer FadeOutlayer2:self.imageLayer2];
        
    } else {
        
        self.imageLayer2.contents = (__bridge id __nullable)(currentImage.CGImage);
        [self overlapAnimationFadeInLayer1:self.imageLayer2 FadeOutlayer2:self.imageLayer];
    }
    
    // button background color animation
    [UIView animateWithDuration:0.5 animations:^{
        self.button.backgroundColor = (UIColor *)self.buttonColors[self.currentPageIndex];
    }];
}

#pragma mark - Page View Controller Data Source
-(UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerAfterViewController:(nonnull UIViewController *)viewController{
    NSUInteger index = ((PageContentViewController*)viewController).pageIndex;
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    
    if (index == [self.pageTexts count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}

-(UIViewController *)pageViewController:(nonnull UIPageViewController *)pageViewController viewControllerBeforeViewController:(nonnull UIViewController *)viewController{
    NSUInteger index = ((PageContentViewController*)viewController).pageIndex;
    
    if (index == 0 || index==NSNotFound) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index];
}
@end
