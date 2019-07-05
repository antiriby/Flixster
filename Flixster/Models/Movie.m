//
//  Movie.m
//  Flixster
//
//  Created by antiriby on 7/3/19.
//  Copyright © 2019 antiriby. All rights reserved.
//

#import "Movie.h"

@implementation Movie

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    
    //Set the poster and backdrop urls
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:dictionary[@"poster_path"]];
    self.posterURL = [NSURL URLWithString:fullPosterURLString];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:dictionary[@"backdrop_path"]];
    self.backdropURL = [NSURL URLWithString:fullBackdropURLString];

    
    
    return self;
}

+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries{
    NSMutableArray *movies = [[NSMutableArray alloc] init];
    for (NSDictionary *dictonary in dictionaries){
        Movie *movie = [[Movie alloc] initWithDictionary:dictonary];
        [movies addObject:movie];
    }
    return movies;
}
@end
