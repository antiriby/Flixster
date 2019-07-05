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

@interface MoviesViewController () <UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *movies;
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

//Requests Top Rated Movies from API
- (void)fetchNowPlayingMovies {
    NSURL *nowPlayingURL = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:nowPlayingURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
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
        else {
            
            NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

            NSDictionary *dictionaries = dataDictionary[@"results"];
            for (NSDictionary *dictonary in dictionaries){
                Movie *movie = [[Movie alloc] initWithDictionary:dictonary];
                [self.movies addObject:movie];
            }

            self.filteredMovies = self.movies;
            NSLog(@"Number of items in movies: %lu",self.movies.count);
            NSLog(@"Number of items in filtered movies: %lu",self.filteredMovies.count);


            [self.activityIndicator stopAnimating];
            [self.tableView reloadData];
            // TODO: Get the array of movies
            // TODO: Store the movies in a property to use elsewhere
            // TODO: Reload your table view data
        }

        [self.refreshControl endRefreshing];

    }];
    [task resume];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    Movie *movie = self.filteredMovies[indexPath.row];
    cell.titleCell.text = movie.title;
    cell.synopsisLabel.text = movie.synopsis;
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie.posterURL;
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    cell.posterView.image = nil;
    [cell.posterView setImageWithURL:posterURL];
    
    return cell;
}

//Search Bar Implementation
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchText.length != 0) {
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(
                                                                       id evaluatedObject, NSDictionary *bindings) {
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
