//
//  MoviesViewController.m
//  Flixster
//
//  Created by antiriby on 6/26/19.
//  Copyright © 2019 antiriby. All rights reserved.
//

#import "Movie.h"
#import "MovieCell.h"
#import "MoviesViewController.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "MovieApiManager.h"

@interface MoviesViewController () <UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIRefreshControl *loadingRefreshControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    self.movies = [[NSMutableArray alloc] init];
    
    //Refresh Control Initialization
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchNowPlayingMovies) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex: 0];
    [self.tableView addSubview:self.refreshControl];
    
    //Activity indicator
    [self.activityIndicator startAnimating];
    [self fetchNowPlayingMovies];
}

-(void)fetchNowPlayingMovies{
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
            
            // The network request has completed, but failed.
            // Invoke the completion block with an error.
            // Think of invoking a block like calling a function with parameters
            //Alert Controller
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Network Error"
                                                                           message:@"Unable to connect to internet."
                                                                    preferredStyle:(UIAlertControllerStyleAlert)];
            // OK action
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * _Nonnull action) {
                                                                 // handle response here.
                                                                 exit(0);
                                                             }];
            [alert addAction:okAction];
            
            [self presentViewController:alert animated:YES completion:^{
                // optional code for what happens after the alert controller has finished presenting
            }];
        }
        self.movies = movies;
        self.filteredMovies = self.movies;
        [self.activityIndicator stopAnimating];
        [self.refreshControl endRefreshing];
        [self.tableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    cell.movie = self.filteredMovies[indexPath.row];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    return cell;
}

//Search Bar Implementation
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            //The issue is with the following line:
            return [evaluatedObject[@"title"] containsString:searchText];
        }];
        
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    Movie *movie = self.movies[indexPath.row];
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailsViewController *detailsViewController = [segue destinationViewController];
    detailsViewController.movie = movie;
}

@end
