//
//  FeedViewController.h
//  IntegratingFacebookTutorial
//
//  Created by Hillary Do on 12/30/14.
//
//

#import <Parse/Parse.h>

@interface FeedViewController : PFQueryTableViewController <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *button;

@end
