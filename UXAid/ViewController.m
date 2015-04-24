//
//  ViewController.m
//  UXAid
//
//  Created by Stuart Farmer on 4/22/15.
//  Copyright (c) 2015 Stuart Farmer. All rights reserved.
//

#import "FAKFontAwesome.h"
#import "ViewController.h"
#import "LFHeatMap.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSMutableArray *views;
    NSMutableArray *points;
    NSMutableArray *weights;
    BOOL isHeat;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set up the labels for the toolbar to look good with FontAwesome
    _viewHeatButton.image = [[FAKFontAwesome eyeIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    _addImageButton.image = [[FAKFontAwesome imageIconWithSize:28] imageWithSize:CGSizeMake(30, 30)];
    _clearButton.image = [[FAKFontAwesome closeIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    
    // Set up arrays for visualizing touches
    points = [[NSMutableArray alloc] init];
    weights = [[NSMutableArray alloc] init];
    
    // Let us know that the heat map is NOT visible and hide it.
    isHeat = NO;
    _heatImageView.hidden = YES;
    
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
        
        // Add the point to the points array
        [points addObject:[NSValue valueWithCGPoint:location]];
        [weights addObject:[NSNumber numberWithInt:5]];
        
        // Redraw the heat map
        LFHeatMap *heatMap = [LFHeatMap heatMapWithRect:self.view.frame boost:1.0 points:points weights:weights];
        _heatImageView.image = heatMap;
    }
}

- (IBAction)clearPressed:(id)sender {
    // If there are no points, then the user has double tapped the clear button, and so remove the image.
    if ([points count] == 0) {
        _imageView.image = nil;
    } else {
        _heatImageView.image = nil;
        [points removeAllObjects];
        [weights removeAllObjects];
    }
    // Always throw it back to the non-heat view. This is something that the user naturally assumes will happen. However, only toggle it if the heat view is shown, obviously.
    if (isHeat) [self toggleHeat];
}

- (IBAction)addImagePressed:(id)sender {
    // If the heat view is on, switch this button to an export button for saving images.
    if (isHeat) {
        // Combine the heat map with the image below it to create an image that shows where users have pressed
        UIGraphicsBeginImageContext(CGSizeMake(_imageView.frame.size.width, _imageView.frame.size.height));
        UIImage *a = _imageView.image;
        [a drawAtPoint:CGPointMake(0, 0)];
        
        UIImage *b = _heatImageView.image;
        [b drawAtPoint:CGPointMake(0, 0)];
        
        UIImage *c = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        _imageView.image = c;
    } else {
        // Otherwise, use this button to select an image
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)viewHeatPressed:(id)sender {
    // Toggling of heat view
    [self toggleHeat];
}

#pragma UIImagePickerViewDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Dismiss picker view controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Set image view to the image
    NSLog(@"%@", info);
    _imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}

-(void) toggleHeat {
    if (isHeat) {
        // Toggle off
        isHeat = NO;
        _heatImageView.hidden = YES;
        _viewHeatButton.image = [[FAKFontAwesome eyeIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
        
        // Adjust image button
        _addImageButton.image = [[FAKFontAwesome imageIconWithSize:28] imageWithSize:CGSizeMake(30, 30)];
        
    } else {
        // Toggle on
        isHeat = YES;
        _heatImageView.hidden = NO;
        _viewHeatButton.image = [[FAKFontAwesome eyeSlashIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
        
        // Adjust image button
        _addImageButton.image = [[FAKFontAwesome saveIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    }
}
@end
