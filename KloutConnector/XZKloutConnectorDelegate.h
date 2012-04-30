//
//  XZKloutConnectorDelegate.h
//  KloutConnector
//
//  Created by Camille Kander on 02/03/12.
//  Copyright (c) 2012 Supinfo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XZKloutConnectorDelegate <NSObject>

- (void)hasReceivedKloutScore:(NSNumber *)score forUserNamed:(NSString *)username;
- (void)hasReceivedKloutInfo:(NSDictionary *)info forUserNamed:(NSString *)username;
- (void)hasReceivedKloutTopics:(NSArray *)topics forUserNamed:(NSString *)username;
- (void)hasReceivedKloutInfluencers:(NSArray *)influencers forUserNamed:(NSString *)username;
- (void)hasReceivedKloutInfluencees:(NSArray *)influencees forUserNamed:(NSString *)username;

@end
