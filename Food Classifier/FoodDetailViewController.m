//
//  FoodDetailViewController.m
//  Food Classifier
//
//  Created by Nikhil Khanna on 3/24/15.
//  Copyright (c) 2015 Dato. All rights reserved.
//

#import "FoodDetailViewController.h"
#import <AsyncImageView/AsyncImageView.h>
@interface FoodDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *foodImageView;
@property (weak, nonatomic) IBOutlet UILabel *proteinLabel;
@property (weak, nonatomic) IBOutlet UILabel *carbsLabel;
@property (weak, nonatomic) IBOutlet UILabel *fatLabel;
@property (weak, nonatomic) IBOutlet UILabel *energyLabel;
@property (weak, nonatomic) IBOutlet UILabel *similarFoodsLabel;

@end

@implementation FoodDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@", self.foodDictionary);
    self.titleLabel.text = self.foodDictionary[@"product_name"];
    self.foodImageView.image = self.foodImage;
    if(self.foodDictionary[@"proteins_100g"] != nil) {
        self.proteinLabel.text = [NSString stringWithFormat:@"grams of protein: %@", self.foodDictionary[@"proteins_100g"]];
    }
    if(self.foodDictionary[@"fat_100g"] != nil) {
        self.fatLabel.text = [NSString stringWithFormat:@"grams of fat: %@", self.foodDictionary[@"fat_100g"]];
    }
    if(self.foodDictionary[@"carbohydrates_100g"] != nil) {
        self.carbsLabel.text = [NSString stringWithFormat:@"grams of carbs: %@", self.foodDictionary[@"carbohydrates_100g"]];
    }
    if(self.foodDictionary[@"energy_100g"] != nil) {
        self.energyLabel.text = [NSString stringWithFormat:@"kj per 100g: %@", self.foodDictionary[@"energy_100g"]];
    }
    NSArray* similarArray = self.foodDictionary[@"similar_foods"];
    if(similarArray != nil) {
        NSMutableString* similarListString = [NSMutableString stringWithString:@"Similar Items: "];
        for (int i = 0; i < similarArray.count; i++) {
            [similarListString appendString:similarArray[i]];
            if(i != similarArray.count-1) {
                [similarListString appendString:@", "];
            }
        }
        self.similarFoodsLabel.text = similarListString;
    }
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
