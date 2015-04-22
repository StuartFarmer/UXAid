//
//  ViewController.h
//  UXAid
//
//  Created by Stuart Farmer on 4/22/15.
//  Copyright (c) 2015 Stuart Farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

- (IBAction)clearPressed:(id)sender;
- (IBAction)addImagePressed:(id)sender;

@end

