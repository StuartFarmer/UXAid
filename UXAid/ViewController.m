//
//  ViewController.m
//  UXAid
//
//  Created by Stuart Farmer on 4/22/15.
//  Copyright (c) 2015 Stuart Farmer. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSMutableArray *points;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self.view];
        NSLog(@"%f, %f", location.x, location.y);
        
    }
}

@end
