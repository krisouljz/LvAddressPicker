//
//  AddressFletModel.h
//  AddressPicker
//
//  Created by krisouljz on 07/19/2018.
//  Copyright (c) 2018 krisouljz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressFletModel : NSObject

@property (nonatomic,copy) NSString *citycode;

@property (nonatomic,copy) NSString *adcode;

@property (nonatomic,copy) NSString *name;

@property (nonatomic,copy) NSString *center;

@property (nonatomic,copy) NSString *level;

@property (nonatomic,strong) NSArray *districts;


@end
