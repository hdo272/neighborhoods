//
//  MyFeedController.h
//  IntegratingFacebookTutorial
//
//  Created by Hillary Do on 12/30/14.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MyFeedController : UIViewController <UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myTextField;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end
