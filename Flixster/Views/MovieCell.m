//
//  MovieCell.m
//  Flixster
//
//  Created by antiriby on 6/26/19.
//  Copyright © 2019 antiriby. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMovie:(Movie *)movie {
    // Since we're replacing the default setter, we have to set the underlying private storage _movie ourselves.
    // _movie was an automatically declared variable with the @propery declaration.
    // You need to do this any time you create a custom setter.
    _movie = movie;
    
    self.titleCell.text = self.movie.title;
    self.synopsisLabel.text = self.movie.synopsis;
    self.posterView.image = nil;
    
    if (self.movie.posterURL != nil) {
        [self.posterView setImageWithURL:self.movie.posterURL];
    }
}

@end
