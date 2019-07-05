//
//  Movie.h
//  Flixster
//
//  Created by antiriby on 7/3/19.
//  Copyright © 2019 antiriby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSString *posterURL;
@property (nonatomic, strong) NSString *backdropURL;

-(id)initWithDictionary:(NSDictionary *)dictionary;
+(NSArray *)moviesWithDictionaries:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
