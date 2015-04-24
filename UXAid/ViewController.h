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
@property (strong, nonatomic) IBOutlet UIBarButtonItem *clearButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addImageButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *viewHeatButton;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIImageView *heatImageView;

- (IBAction)clearPressed:(id)sender;
- (IBAction)addImagePressed:(id)sender;
- (IBAction)viewHeatPressed:(id)sender;

@end

