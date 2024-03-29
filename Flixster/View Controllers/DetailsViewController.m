//
//  DetailsViewController.m
//  Flixster
//
//  Created by antiriby on 6/26/19.
//  Copyright © 2019 antiriby. All rights reserved.
//

#import "Movie.h"
#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backdropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sypnopsisLabel;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.posterView setImageWithURL:self.movie.posterURL];
    [self.backdropView setImageWithURL:self.movie.backdropURL];
    
    self.titleLabel.text = self.movie.title;
    self.sypnopsisLabel.text = self.movie.synopsis;
    
    [self.titleLabel sizeToFit];
    [self.sypnopsisLabel sizeToFit];
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
