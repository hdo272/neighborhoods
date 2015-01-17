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

@interface MyFeedController ()

@end

@implementation MyFeedController

- (void)viewDidLoad {
    [super viewDidLoad];
    // removes back button
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
    PFQueryTableViewController *controller = [[PFQueryTableViewController alloc] initWithClassName:@"testObject"];
    [self addChildViewController:controller];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    [testObject saveInBackground];
}

- (IBAction)Settings:(id)sender {
    NSLog(@"Settings");
    
    UserDetailsViewController *usersDetailsViewController = [[UserDetailsViewController alloc] init];
    
    [self presentViewController:usersDetailsViewController animated:YES completion:nil];
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
