//
//  FeedViewController.m
//  IntegratingFacebookTutorial
//
//  Created by Hillary Do on 12/30/14.
//
//

#import "FeedViewController.h"
#import "MyFeedController.h"

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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (PFQuery *)queryForTable {
    PFGeoPoint *userLocation;
    if ([PFUser currentUser]) {
        userLocation = [PFUser currentUser][@"currentLocation"];
    }
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    [query whereKey:@"location" nearGeoPoint:userLocation withinMiles:10.0];
    [query findObjects];
    
    // If no objects are loaded in memory, we look to the cache
    // first to fill the table and then subsequently do a query
    // against the network.
    if ([self.objects count] == 0) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }
    //[query orderByAscending:@"createdAt"];
    
    return query;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, self.view.frame.size.width - 70, 30)];
    UITextField *txt = [[UITextField alloc] init];
    txt.text = @"header";
    txt.enabled =tableView.editing;
    txt.borderStyle = UITextBorderStyleRoundedRect;
    return tableHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

-(void)viewDidLayoutSubviews
{
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.imageView.frame = (CGRect){{0.0f, 0.0f}, 70, 70};
    cell.imageView.layer.cornerRadius = cell.imageView.frame.size.height / 2.0f;
    cell.imageView.layer.masksToBounds = YES;
    cell.imageView.layer.borderWidth = 0;
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *CellIdentifier = @"Cell";
    //tableView.backgroundColor = [UIColor colorWithRed:(255/255.0) green:(191/255.0) blue:(198/255.0) alpha:1];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //cell.backgroundColor = [UIColor redColor];
     
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:15];
        //retrieve post's userID
        NSString *userPostID = [object objectForKey:@"ParseUserID"];
        //query for User
        PFQuery *query = [PFUser query];
        [query whereKey:@"username" equalTo:userPostID];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error){
                //NSLog(@"ObjectsAgain: %@", objects);
                for (PFObject *object in objects) {
                    NSDictionary *fbInfo = [object objectForKey:@"profile"];
                    NSString *userProfilePhotoURLString = [fbInfo objectForKey:@"pictureURL"];
                    // Download the user's facebook profile picture
                    if (userProfilePhotoURLString) {
                        NSLog(@"value:%@", userProfilePhotoURLString);
                        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
                        //NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
                        //UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userProfilePhotoURLString]]];
                        NSData *profilePictureData = [NSData dataWithContentsOfURL:pictureURL];
                        cell.imageView.image = [UIImage imageWithData:profilePictureData];
                    }
                }
            }
            
        }];
        // Configure the cell to show todo item with a priority at the bottom
        cell.textLabel.text = [object objectForKey:@"shareText"];
    }
    return cell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // removes back button
    [self.navigationItem setHidesBackButton:YES];
    // Do any additional setup after loading the view.
    PFQueryTableViewController *controller = [[PFQueryTableViewController alloc] initWithClassName:@"testObject"];
    [self addChildViewController:controller];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //Write Button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    //[button setTitle:@"Write" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"edit-50.png"] forState:UIControlStateNormal];
    [button sizeToFit];
    //button.center = CGPointMake(250, 0);
    [button setTag:0];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton =[[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    self.locationManager = [[CLLocationManager alloc]init];
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager startUpdatingLocation];

    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            NSLog(@"User is currently at %f, %f", geoPoint.latitude, geoPoint.longitude);

            [[PFUser currentUser] setObject:geoPoint forKey:@"currentLocation"];
            [[PFUser currentUser] saveInBackground];
        }
        else{
            NSLog(@"uhoh!");
        }
    }];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertView *errorAlert = [[UIAlertView alloc]initWithTitle:@"Error" message:@"There was an error retrieving your location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [errorAlert show];
    NSLog(@"Error: %@",error.description);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"%@", [locations lastObject]);
}

- (void)buttonPressed:(UIButton *)paramSender{
    //UIButton *buttonClicked = (UIButton *)sender;
    NSLog(@"wtf");
    /*PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"shareText"] = self->statusTextField.text;
    if ([PFUser currentUser]) {
        testObject[@"userName"] = [PFUser currentUser][@"profile"][@"name"];
        testObject[@"userID"] = [PFUser currentUser][@"profile"][@"facebookId"];
        //[self _updateProfileData];
    }
    [testObject saveInBackground];*/
    [self _presentFeedViewControllerAnimated:YES];
}

- (void)_presentFeedViewControllerAnimated:(BOOL)animated {
    MyFeedController *detailsViewController = [[MyFeedController alloc] init];
    [self.navigationController pushViewController:detailsViewController animated:animated];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // get the table and search bar bounds
    CGRect tableBounds = self.tableView.bounds;
    CGRect searchBarFrame = self->statusTextField.frame;
    
    // make sure the search bar stays at the table's original x and y as the content moves
    self->statusTextField.frame = CGRectMake(tableBounds.origin.x,
                                      tableBounds.origin.y,
                                      searchBarFrame.size.width,
                                      searchBarFrame.size.height
                                      );
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
