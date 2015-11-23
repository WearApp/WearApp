//
//  SKAPIStoreIndexModel.h
//  Wear
//
//  Created by 孙恺 on 15/11/15.
//  Copyright © 2015年 sunkai. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface SKAPIStoreIndexModel : MTLModel<MTLJSONSerializing>

@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *level;
@property (nonatomic, copy) NSString *detailText;
@property (nonatomic, copy) NSString *otherName;

@end
