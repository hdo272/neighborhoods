//
//  FeedViewController.h
//  IntegratingFacebookTutorial
//
//  Created by Hillary Do on 12/30/14.
//
//

#import <Parse/Parse.h>
#import <CoreLocation/CoreLocation.h>

@interface FeedViewController : PFQueryTableViewController <UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *button;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
