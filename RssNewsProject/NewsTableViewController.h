//
//  FBCDMasterTableViewController.h
//  FailedBankCD
//
//  Created by Admin on 24.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsEntity.h"

@interface NewsTableViewController : UITableViewController

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSArray* listNews;
@property (nonatomic, strong) NSMutableArray* listDate;
@property (nonatomic, strong) NewsEntity* newsEntity;

@end
