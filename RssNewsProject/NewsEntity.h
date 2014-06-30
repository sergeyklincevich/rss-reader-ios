//
//  FailedBankInfo.h
//  FailedBankCD
//
//  Created by Admin on 24.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsEntity;

@interface NewsEntity : NSManagedObject

@property (nonatomic, retain) NSString * describe;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * link;
@property (nonatomic, retain) NSString * linkImage;
@property (nonatomic, retain) NSDate * pubDate;

@end
