//
//  FetchResultController.h
//  QiwiTestFiruz
//
//  Created by Firuz Narzikulov on 26.06.16.
//  Copyright © 2016 Firuz Narzikulov. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface FetchResultController : NSFetchedResultsController

/** Returns transformed viewModel for appropriate objects */
- (id)viewModelAtIndexPath:(NSIndexPath *)indexPath;

/** Returns transformed viewModels for all fetched objects */
- (NSArray *)fetchedViewModels;

@end
