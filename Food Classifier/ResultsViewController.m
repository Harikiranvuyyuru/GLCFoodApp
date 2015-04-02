//
//  ResultsViewController.m
//  Food Classifier
//
//  Created by Nikhil Khanna on 3/10/15.
//  Copyright (c) 2015 Dato. All rights reserved.
//

#import "ResultsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <AsyncImageView/AsyncImageView.h>
#import "FoodDetailViewController.h"

@interface ResultsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *foodTableView;
@property NSArray* possibleProductsArray;
@property NSDictionary* chosenFood;
@property UIImage* chosenFoodImage;
@end

@implementation ResultsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self makeRequest];
    // Do any additional setup after loading the view.
}

-(void)makeRequest {
    self.imageToSend = [self imageResize:self.chosenImage andResizeTo:CGSizeMake(256, 256)];
    
    NSDate *startTime = [NSDate date];
    
    NSString* base64 = [UIImageJPEGRepresentation(self.imageToSend, 1) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString* url = @"http://food-app-491979499.us-west-1.elb.amazonaws.com/data/get_similar_food";
    NSDictionary* params = @{
                             @"api key": @"4b42f06a-87a2-4729-9a73-82b48a1d1b08",
                             @"data": @{
                                     @"image_bytestring":base64
                                }
                             };
    
    AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
    [requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = requestSerializer;
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSDictionary* responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        NSLog(@"%@", responseDict);
        double timePassed = [startTime timeIntervalSinceNow] * -1000.0;
        NSLog(@"time passed since request: %f", timePassed);
        self.possibleProductsArray = responseDict[@"response"];
        [self.foodTableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", error);
    }];
}

-(UIImage *)imageResize :(UIImage*)img andResizeTo:(CGSize)newSize
{
    CGFloat scale = [[UIScreen mainScreen]scale];
    /*You can remove the below comment if you dont want to scale the image in retina   device .Dont forget to comment UIGraphicsBeginImageContextWithOptions*/
    //UIGraphicsBeginImageContext(newSize);
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    [img drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//DELEGATE METHODS FOR TABLE VIEW
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.possibleProductsArray == nil) {
        return 0;
    }
    else {
        return self.possibleProductsArray.count;
    }
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"Cell"];
    }
    NSURL *url = [NSURL URLWithString:self.possibleProductsArray[indexPath.row][@"image_url"]];
    NSError* error;
    NSData *imgData = [NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:&error];
    if(error) {
        NSLog(@"%@", error);
    }
    
    UIImage* img = [UIImage imageWithData:imgData];
    
    cell.imageView.image = img;
    CGSize itemSize = CGSizeMake(100, 100);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSString* selectedText = [self productDescriptionFromDictionary:self.possibleProductsArray[indexPath.row]];
    [cell.textLabel setText:selectedText];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.chosenFood = [self.possibleProductsArray objectAtIndex:indexPath.row];
    self.chosenFoodImage = [tableView cellForRowAtIndexPath:indexPath].imageView.image;
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    [self performSegueWithIdentifier:@"foodSelectedSegue" sender:self];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(NSString*) productDescriptionFromDictionary: (NSDictionary *)dict {
    if(![dict[@"product_name"] isEqualToString:@""]) {
        return dict[@"product_name"];
    }
    if(![dict[@"generic_name"] isEqualToString:@""]) {
        return dict[@"generic_name"];
    }
    else {
        return [NSString stringWithFormat:@"%@", dict[@"reference_label"]];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];// this will do the trick
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FoodDetailViewController* destinationViewController = [segue destinationViewController];
    destinationViewController.foodDictionary = self.chosenFood;
    destinationViewController.foodImage = self.chosenFoodImage;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
