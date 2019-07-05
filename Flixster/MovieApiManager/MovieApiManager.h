//
//  MovieApiManager.h
//  Flixster
//
//  Created by antiriby on 7/4/19.
//  Copyright © 2019 antiriby. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieApiManager : NSObject
@property (nonatomic, strong) NSURLSession *session;
- (id)init;
- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;
@end

NS_ASSUME_NONNULL_END
