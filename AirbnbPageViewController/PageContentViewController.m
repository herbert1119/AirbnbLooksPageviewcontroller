//
//  PageContentViewController.m
//  AirbnbPageViewController
//
//  Created by Bo Han on 2015-06-18.
//  Copyright © 2015 Bo Han. All rights reserved.
//

#import "PageContentViewController.h"

@interface PageContentViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation PageContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.textView.text = self.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
