//
//  MyFeedController.m
//  IntegratingFacebookTutorial
//
//  Created by Hillary Do on 12/30/14.
//
//

#import "MyFeedController.h"
#import <Parse/Parse.h>
#import "UserDetailsViewController.h"
#import "FeedViewController.h"

@interface MyFeedController()

@end

@implementation MyFeedController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // removes back button
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
    PFQueryTableViewController *controller = [[PFQueryTableViewController alloc] initWithClassName:@"testObject"];
    [self addChildViewController:controller];
    
    /*self.locationManager = [[CLLocationManager alloc]init]; // initializing locationManager
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; // setting the accuracy
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];  //requesting location updates*/

}

/*-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}*/


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"You entered %@",self.myTextField.text);
    [self.myTextField resignFirstResponder];
    return YES;
}

- (IBAction)TextStatus:(id)sender {
    //saves User's text
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"shareText"] = self.myTextField.text;
    if ([PFUser currentUser]) {
        testObject[@"userName"] = [PFUser currentUser][@"profile"][@"name"];
        testObject[@"userID"] = [PFUser currentUser][@"profile"][@"facebookId"];
        //[self _updateProfileData];
    }
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            NSLog(@"SAVEOBJECT AT %f, %f", geoPoint.latitude, geoPoint.longitude);
            testObject[@"shareText"] = @"hi";
            //[testObject saveInBackground];
            [testObject setObject:geoPoint forKey:@"location"];
        }
        else{
            NSLog(@"uhoh!");
        }
    }];
    [testObject saveInBackground];
    [self _presentFeedViewControllerAnimated:YES];
}

- (void)_presentFeedViewControllerAnimated:(BOOL)animated {
    FeedViewController *detailsViewController = [[FeedViewController alloc] init];
    [self.navigationController pushViewController:detailsViewController animated:animated];
}

- (IBAction)Settings:(id)sender {
    NSLog(@"Settings");
    [self _presentUserDetailsViewControllerAnimated:YES];
    
}

- (void)_presentUserDetailsViewControllerAnimated:(BOOL)animated {
    UserDetailsViewController *detailsViewController = [[UserDetailsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [self.navigationController pushViewController:detailsViewController animated:animated];
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
