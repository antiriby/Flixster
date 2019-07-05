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
    self.posterURL = dictionary[@"poster_path"];
    self.backdropURL = dictionary[@"backdrop_path"];
    return self;
}

//+ (NSArray *)moviesWithDictionaries:(NSArray *)dictionaries{
//
//}
@end
