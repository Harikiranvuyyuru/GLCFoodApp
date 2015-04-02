//
//  CameraViewController.h
//  FoodClassifier
//
//  Created by Nikhil Khanna on 2/3/15.
//  Copyright (c) 2015 Dato. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) UIImage* selectedImage;

- (IBAction)takePhoto:  (UIButton *)sender;
- (IBAction)selectPhoto:(UIButton *)sender;

@end
