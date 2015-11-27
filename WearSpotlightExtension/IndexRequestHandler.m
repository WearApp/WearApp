//
//  IndexRequestHandler.m
//  WearSpotlightExtension
//
//  Created by 孙恺 on 15/11/24.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import "IndexRequestHandler.h"

@implementation IndexRequestHandler

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexAllSearchableItemsWithAcknowledgementHandler:(void (^)(void))acknowledgementHandler {
    // Reindex all data with the provided index
    
    acknowledgementHandler();
}

- (void)searchableIndex:(CSSearchableIndex *)searchableIndex reindexSearchableItemsWithIdentifiers:(NSArray <NSString *> *)identifiers acknowledgementHandler:(void (^)(void))acknowledgementHandler {
    // Reindex any items with the given identifiers and the provided index
    
    acknowledgementHandler();
}

@end
