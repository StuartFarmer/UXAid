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
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:self.view];
        NSLog(@"%f, %f", location.x, location.y);
        
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
}

- (IBAction)addImagePressed:(id)sender {
    // Fire up the ol' image picker
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

- (IBAction)viewHeatPressed:(id)sender {
    // Toggling of heat view
    if (isHeat) {
        // Toggle off
        isHeat = NO;
        _heatImageView.hidden = YES;
        _viewHeatButton.image = [[FAKFontAwesome eyeIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
        
    } else {
        // Toggle on
        isHeat = YES;
        _heatImageView.hidden = NO;
        _viewHeatButton.image = [[FAKFontAwesome eyeSlashIconWithSize:30] imageWithSize:CGSizeMake(30, 30)];
    }
}

#pragma UIImagePickerViewDelegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    // Dismiss picker view controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Set image view to the image
    NSLog(@"%@", info);
    _imageView.image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
}
@end
