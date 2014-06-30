//
//  NewsTableViewController.m
//
//  Created by Admin on 24.06.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "NewsTableViewController.h"
#import "UIWebViewController.h"
#import "NewsEntity.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Reachability.h"

@interface NewsTableViewController () <NSXMLParserDelegate> {
    NSXMLParser *parser;
    NSMutableDictionary *item;
    NSMutableString *title;
    NSMutableString *description;
    NSMutableString *link;
    NSMutableString *linkImage;
    NSString *element;
    NSDate *pubDate;
    NSMutableString *pubDateString;
}
@end

@implementation NewsTableViewController

@synthesize managedObjectContext;
@synthesize listNews;
@synthesize listDate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadDataFromServerUpdateInUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)loadDataFromServerUpdateInUI
{
    if ([self connectedToInternet])
    {
        
        NSURL *url = [NSURL URLWithString:@"http://news.tut.by/rss"];
        parser = [[NSXMLParser alloc] initWithContentsOfURL:url];
        [parser setDelegate:self];
        [parser setShouldResolveExternalEntities:NO];
        [parser parse];
    } else
    {
        NSString *asd = @"Internet connection is not available!";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check Internet" message:asd
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        [self loadDataFromDBUpdateInUI];
    }
}

- (BOOL)connectedToInternet
{
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        NSLog(@"There IS NO internet connection");
    } else {
        NSLog(@"There IS internet connection");
    }
    return (networkStatus == NotReachable) ? NO : YES;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [listDate count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count = 0;
    for (NewsEntity *newsEntity in listNews) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        
        NSString *date = [dateFormatter stringFromDate:newsEntity.pubDate];

        if ([[listDate objectAtIndex:section] isEqualToString:date])
        {
            count++;
        }
    }
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [listDate objectAtIndex:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    int positionInList = 0;
    if (indexPath.section == 0)
    {
        positionInList = indexPath.row;
    } else
    {
        for (int i = 0; i < indexPath.section ; i++) {
            positionInList += [self tableView:tableView numberOfRowsInSection:i];
        }
        positionInList +=  + indexPath.row;
    }
    
//    // Configure the cell...
    NewsEntity *info = [listNews objectAtIndex:positionInList];
    cell.textLabel.text = info.title;
    cell.detailTextLabel.text = info.describe;
    UITextField *dateCustomText = (UITextField *)[cell viewWithTag:101];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy HH:mm"];
    
    NSString *stringDate = [dateFormatter stringFromDate:info.pubDate];
    
    dateCustomText.text = stringDate;
    
    // Here we use the new provided setImageWithURL: method to load the web image
    
    NSString *testStr = info.linkImage;
    testStr = [testStr substringWithRange:NSMakeRange(1, [testStr length] - 2)];
    
    NSURL * urlImage = [NSURL URLWithString:testStr];

    
    [cell.imageView setImageWithURL:urlImage placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NewsEntity *newsEntity = self.listNews[indexPath.row];
        NSString *string = newsEntity.link;

        [[segue destinationViewController] setOpenURL:string];
        
    }
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    
    element = elementName;
    
    if ([element isEqualToString:@"item"]) {
        item          = [[NSMutableDictionary alloc] init];
        title         = [[NSMutableString alloc] init];
        description   = [[NSMutableString alloc] init];
        link          = [[NSMutableString alloc] init];
        pubDateString = [[NSMutableString alloc] init];
    }
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    
    if ([elementName isEqualToString:@"item"]) {
        
        NSManagedObjectContext *context = [self managedObjectContext];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"NewsEntity" inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        
        // Set predicate and sort orderings...
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title=%@)",title];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        self.listNews = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        
        if ([listNews count] < 1) {
            
            NewsEntity *newsEntity = [NSEntityDescription insertNewObjectForEntityForName:@"NewsEntity" inManagedObjectContext:[self managedObjectContext]];
            newsEntity.title = title;
            
            [link deleteCharactersInRange:NSMakeRange([link length] - 2, 2)];
            newsEntity.link = link;
  
            NSString *firstSearchItem = @"<img src=";
            NSString *secondSearchItem = @" width";
            
            NSString *imageLink;
            int r1 = [description rangeOfString:firstSearchItem].location;
            int r2 = [description rangeOfString:secondSearchItem].location;

            
            if (r1 >= 0 && r2 >= 0 && r1 != NSNotFound && r2 != NSNotFound)
            {
                imageLink = [description substringWithRange:NSMakeRange([firstSearchItem length], r2 - [firstSearchItem length])];
                
            }
            newsEntity.linkImage = imageLink;
            firstSearchItem = @" />";
            secondSearchItem = @"<br";
            
            r1 = [description rangeOfString:firstSearchItem].location;
            r2 = [description rangeOfString:secondSearchItem].location;
           
            NSString *desc;
            if (r1 >= 0 && r2 >= 0 && r1 != NSNotFound && r2 != NSNotFound)
            {
                desc = [description substringWithRange:NSMakeRange(r1 + [firstSearchItem length], r2 - r1 - [secondSearchItem length])];
            }
            
            newsEntity.describe = desc;
            
            // Convert string to date object
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z\n"];
            NSDate *date = [dateFormat dateFromString:pubDateString];
            newsEntity.pubDate = date;

            
            if (![context save:&error]) {
                NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
            }
        }
        
     }
    
}

- (void)saveDateIfNeeded
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd MMM yyyy"];
    
    for (NewsEntity *news in listNews) {
        NSString *simpleDate = [dateFormat stringFromDate:news.pubDate];
        
        BOOL isDatesEquales = NO;
        for (NSString *date in listDate){
            if ([date isEqualToString:simpleDate])
            {
                isDatesEquales = YES;
                break;
            }
        }
        if (!isDatesEquales)
        {
        [listDate addObject:simpleDate];
        }
    }
    
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([element isEqualToString:@"title"]) {
        [title appendString:string];
    } else if ([element isEqualToString:@"description"]) {
        [description appendString:string];
    } else if ([element isEqualToString:@"link"]) {
        [link appendString:string];
    } else if ([element isEqualToString:@"pubDate"]) {
        [pubDateString appendString:string];
    }
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    [self loadDataFromDBUpdateInUI];
}

- (void)loadDataFromDBUpdateInUI
    {
        listDate = [[NSMutableArray alloc] init];

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription
                                       entityForName:@"NewsEntity" inManagedObjectContext:managedObjectContext];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortByDate = [[NSSortDescriptor alloc] initWithKey:@"pubDate" ascending:NO];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects: sortByDate, nil];
        [fetchRequest setSortDescriptors:sortDescriptors];
        
        NSError *error;
        self.listNews = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
        [self saveDateIfNeeded];
        
        
//        self.title = @"TUT.BY NEWS";
        
        [self.tableView reloadData];

    }

- (void) deleteAllObjects: (NSString *) entityDescription  {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *items = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
    	[managedObjectContext deleteObject:managedObject];
    	NSLog(@"%@ object deleted", entityDescription);
    }
    if (![managedObjectContext save:&error]) {
    	NSLog(@"Error deleting %@ - error:%@",entityDescription,error);
    }
    
}

-(IBAction) buttonUpdateClicked
{
    listNews = nil;
    [self.tableView reloadData];
    [self loadDataFromServerUpdateInUI];
}

-(IBAction) buttonRemoveAllDataClicked
{
    listNews = nil;
    [self deleteAllObjects:@"NewsEntity"];
    [self.tableView reloadData];
    [self loadDataFromDBUpdateInUI];
}


@end