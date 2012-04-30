//
//  XZKloutConnector.m
//  KloutConnector
//
//  Created by Camille Kander on 02/03/12.
//  Copyright (c) 2012 Camille Kander. All rights reserved.
//

#import "XZKloutConnector.h"
#import "XZKloutConnectorDelegate.h"
#import "Key.h"


@implementation XZKloutConnector

@synthesize operationQueue = _operationQueue;

- (XZKloutConnector *)init {
    self = [super init];
    self.operationQueue = [[NSOperationQueue alloc] init];
    return self;
}

+ (XZKloutConnector *)sharedKloutConnector {
    static XZKloutConnector *sharedConnector = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConnector = [[XZKloutConnector alloc] init];
    });
    return sharedConnector;
}

- (NSString *)apiKey {
    return kKloutAPIKey;
}

- (void)queryScoreForUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate handler:(void (^)(void))handler {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/1/klout.json?users=%@&key=%@", username, self.apiKey]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Response status code = %i", httpResponse.statusCode);
        if (httpResponse.statusCode != 200) {
            NSLog(@"Error: Klout did not respond.");
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([[dict objectForKey:@"body"] objectForKey:@"error"]) {
                NSLog(@"Klout responded. Error: %@", [[dict objectForKey:@"body"] objectForKey:@"error"]);
            } else {
                NSLog(@"Klout responded. Response: \n%@", dict);
                if (handler) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [delegate hasReceivedKloutScore:[[[dict objectForKey:@"users"] objectAtIndex:0] objectForKey:@"kscore"] forUserNamed:username];
                        handler();
                    });
                } else {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        [delegate hasReceivedKloutScore:[[[dict objectForKey:@"users"] objectAtIndex:0] objectForKey:@"kscore"] forUserNamed:username];
                    });
                }
            }
        }
    }];
}

- (void)queryScoreForUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate {
    [self queryScoreForUserNamed:username delegate:delegate handler:nil];
}

- (void)queryInfosForUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/1/users/show.json?users=%@&key=%@", username, self.apiKey]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Response status code = %i", httpResponse.statusCode);
        if (httpResponse.statusCode != 200) {
            NSLog(@"Error: Klout did not respond.");
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([[dict objectForKey:@"body"] objectForKey:@"error"]) {
               NSLog(@"Klout responded. Error: %@", [[dict objectForKey:@"body"] objectForKey:@"error"]);
            } else {
                NSLog(@"Klout responded. Response: \n%@", dict);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate hasReceivedKloutInfo:[[dict objectForKey:@"users"] objectAtIndex:0] forUserNamed:username];
                });
            }
        }
    }];
}

- (void)queryTopicsForUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/1/users/topics.json?users=%@&key=%@", username, self.apiKey]];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Response status code = %i", httpResponse.statusCode);
        if (httpResponse.statusCode != 200) {
            NSLog(@"Error: Klout did not respond.");
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([[dict objectForKey:@"body"] objectForKey:@"error"]) {
                 NSLog(@"Klout responded. Error: %@", [[dict objectForKey:@"body"] objectForKey:@"error"]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate hasReceivedKloutTopics:nil forUserNamed:username];
                });
            } else {
                NSLog(@"Klout responded. Response: \n%@", dict);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate hasReceivedKloutTopics:[[[dict objectForKey:@"users"] objectAtIndex:0] objectForKey:@"topics"] forUserNamed:username];
                });
            }
        }
    }];
}

- (void)queryUsersInfluencedByUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/1/soi/influencer_of.json?users=%@&key=%@",  username, self.apiKey] ];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Response status code = %i", httpResponse.statusCode);
        if (httpResponse.statusCode != 200) {
            NSLog(@"Error: Klout did not respond.");
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([[dict objectForKey:@"body"] objectForKey:@"error"]) {
                NSLog(@"Klout responded. Error: %@", [[dict objectForKey:@"body"] objectForKey:@"error"]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate hasReceivedKloutInfluencees:nil forUserNamed:username];
                });
            } else {
                NSLog(@"Klout responded. Response: \n%@", dict);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate hasReceivedKloutInfluencees:[[[dict objectForKey:@"users"] objectAtIndex:0] objectForKey:@"influencees"] forUserNamed:username];
                });
            }
        }
    }];
}

- (void)queryInfluencersOfUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.klout.com/1/soi/influenced_by.json?users=%@&key=%@",  username, self.apiKey] ];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:self.operationQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
        NSLog(@"Response status code = %i", httpResponse.statusCode);
        if (httpResponse.statusCode != 200) {
            NSLog(@"Error: Klout did not respond.");
        } else {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if ([[dict objectForKey:@"body"] objectForKey:@"error"]) {
                NSLog(@"Klout responded. Error: %@", [[dict objectForKey:@"body"] objectForKey:@"error"]);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate hasReceivedKloutInfluencers:nil forUserNamed:username];
                });
            } else {
                NSLog(@"Klout responded. Response: \n%@", dict);
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [delegate hasReceivedKloutInfluencers:[[[dict objectForKey:@"users"] objectAtIndex:0] objectForKey:@"influencers"] forUserNamed:username];
                });
            }
        }
    }];
}

@end
