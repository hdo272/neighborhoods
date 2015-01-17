//
//  FeedViewController.m
//  IntegratingFacebookTutorial
//
//  Created by Hillary Do on 12/30/14.
//
//

#import "FeedViewController.h"

@interface FeedViewController ()

@end

@implementation FeedViewController{
    UITextField *statusTextField;
}

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self){
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 25;
        [self.tableView setContentInset:UIEdgeInsetsMake(50,0,0,0)];
    }
    return self;
}

- (PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    
    //[query orderByAscending:@"createdAt"];
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        if ([indexPath section] == 0 && [indexPath row] == 0) {
            
            //TextField
            self->statusTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 10, 185, 30)];
            self->statusTextField.adjustsFontSizeToFitWidth = YES;
            self->statusTextField.textColor = [UIColor blackColor];
            //if ([indexPath row] == 0) {
                statusTextField.placeholder = @"Share a message!";
                statusTextField.returnKeyType = UIReturnKeyNext;
            //}
            self->statusTextField.backgroundColor = [UIColor whiteColor];
            self->statusTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            self->statusTextField.autocapitalizationType = UITextAutocapitalizationTypeNone; // no auto capitalization support
            self->statusTextField.tag = 0;
            
            self->statusTextField.clearButtonMode = UITextFieldViewModeNever; // no clear 'x' button to the right
            [self->statusTextField setEnabled: YES];
            self->statusTextField.delegate = self;
            
            [cell.contentView addSubview:self->statusTextField];
            
            //Post Button
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            [button setTitle:@"Press Me" forState:UIControlStateNormal];
            [button sizeToFit];
            button.center = CGPointMake(320/2, 60);
            [button setTag:0];
            [button addTarget:self action:@selector(buttonPressed) forControlEvents:UIControlEventAllEditingEvents];
            [self.view addSubview:button];
        }
    }
    
    // Configure the cell to show todo item with a priority at the bottom
    cell.textLabel.text = [object objectForKey:@"shareText"];
    
    return cell;
}

- (void)buttonPressed{
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"shareText"] = self->statusTextField.text;
    if ([PFUser currentUser]) {
        testObject[@"userName"] = [PFUser currentUser][@"profile"][@"name"];
        testObject[@"userID"] = [PFUser currentUser][@"profile"][@"facebookId"];
        //[self _updateProfileData];
    }
    [testObject saveInBackground];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // removes back button
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
    PFQueryTableViewController *controller = [[PFQueryTableViewController alloc] initWithClassName:@"testObject"];
    [self addChildViewController:controller];
    // Do any additional setup after loading the view.
}

/*- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"You entered %@",self.myTextField.text);
    [self.myTextField resignFirstResponder];
    return YES;
}*/

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
