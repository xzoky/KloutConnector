//
//  XZKloutConnector.h
//  KloutConnector
//
//  Created by Camille Kander on 02/03/12.
//  Copyright (c) 2012 Supinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kKloutColorOrange,
    kKloutColorBlue,
    kKloutColorWhite,
    kKloutColorGrey,
    kKloutColorBrown
} kKloutColor;

@protocol XZKloutConnectorDelegate;

@interface XZKloutConnector : NSObject

+ (XZKloutConnector *)sharedKloutConnector;

- (NSString *)apiKey;
- (void)queryScoreForUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate;
- (void)queryScoreForUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate handler:(void(^)(void))handler;
- (void)queryInfosForUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate;
- (void)queryTopicsForUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate;
- (void)queryUsersInfluencedByUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate;
- (void)queryInfluencersOfUserNamed:(NSString *)username delegate:(id<XZKloutConnectorDelegate>)delegate;

@property (readwrite, strong) NSOperationQueue *operationQueue;

@end
