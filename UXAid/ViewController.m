//
//  ViewController.m
//  UXAid
//
//  Created by Stuart Farmer on 4/22/15.
//  Copyright (c) 2015 Stuart Farmer. All rights reserved.
//

#import "ViewController.h"
#import "LFHeatMap.h"
#import "FAKFontAwesome.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UIImage *outputImage;
    
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

#pragma UI Methods
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
        UIGraphicsBeginImageContext(_imageView.frame.size);
        
        [_imageView.image drawInRect:self.view.frame];
        [_heatImageView.image drawInRect:self.view.frame];
        
        outputImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // Then throw up the option to save this image.
        UIImageWriteToSavedPhotosAlbum(outputImage, nil, @selector(saved:error:context:), nil);

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

#pragma Non-UI Methods
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

- (void)saved:(UIImage *)image error:(NSError *)error context:(void*)context {
    if (error) {
        // Display an error message
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Error"
                              message:error.localizedDescription
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    } else {
        // Notify user save was a success
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Saved!"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}
@end
