//
//  ViewController.m
//  UXAid
//
//  Created by Stuart Farmer on 4/22/15.
//  Copyright (c) 2015 Stuart Farmer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSMutableArray *views;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set tag to 0 to prevent deletion
    _toolbar.tag = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self.view];
        NSLog(@"%f, %f", location.x, location.y);
        
        // Create the view
        UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(location.x-5, location.y-5, 10, 10)];
        circleView.alpha = 0.5;
        circleView.layer.cornerRadius = 5;
        circleView.backgroundColor = [UIColor blueColor];
        circleView.tag = [views count]+1;
        [views addObject:circleView];
        [self.view addSubview:circleView];
    }
}

- (IBAction)clearPressed:(id)sender {
    // Remove all views except the toolbar
    for (UIView *view in [self.view subviews]) {
        if(view.tag != 0)[view removeFromSuperview];
    }
}
@end
