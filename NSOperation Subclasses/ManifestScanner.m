//
//  ManifestScanner.m
//  MunkiAdmin
//
//  Created by Hannes Juutilainen on 6.10.2010.
//

#import "ManifestScanner.h"
#import "CatalogMO.h"
#import "CatalogInfoMO.h"
#import "ApplicationMO.h"
#import "PackageMO.h"
#import "ApplicationProxyMO.h"
#import "ManagedInstallMO.h"
#import "ManagedUninstallMO.h"
#import "ManagedUpdateMO.h"
#import "OptionalInstallMO.h"
#import "StringObjectMO.h"
#import "ConditionalItemMO.h"

@implementation ManifestScanner

@synthesize currentJobDescription;
@synthesize fileName;
@synthesize sourceURL;
@synthesize delegate;
@synthesize pkginfoKeyMappings;
@synthesize receiptKeyMappings;
@synthesize installsKeyMappings;

- (NSUserDefaults *)defaults
{
	return [NSUserDefaults standardUserDefaults];
}


- (id)initWithURL:(NSURL *)src {
	if ((self = [super init])) {
		if ([self.defaults boolForKey:@"debug"]) NSLog(@"Initializing manifest operation");
		self.sourceURL = src;
		self.fileName = [self.sourceURL lastPathComponent];
		self.currentJobDescription = @"Initializing manifest scan operation";
		
	}
	return self;
}

- (void)dealloc {
	[fileName release];
	[currentJobDescription release];
	[sourceURL release];
	[delegate release];
	[pkginfoKeyMappings release];
	[receiptKeyMappings release];
	[installsKeyMappings release];
	[super dealloc];
}

- (void)contextDidSave:(NSNotification*)notification 
{
	[[self delegate] performSelectorOnMainThread:@selector(mergeChanges:) 
									  withObject:notification 
								   waitUntilDone:YES];
}

- (id)matchingObjectForString:(NSString *)aString
{
    NSPredicate *appPred = [NSPredicate predicateWithFormat:@"munki_name == %@", aString];
    NSUInteger foundIndex = [apps indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [appPred evaluateWithObject:obj];
    }];
    
    if (foundIndex != NSNotFound) {
        return [apps objectAtIndex:foundIndex];
    } else {
        NSPredicate *pkgPred = [NSPredicate predicateWithFormat:@"titleWithVersion == %@", aString];
        NSUInteger foundPkgIndex = [packages indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [pkgPred evaluateWithObject:obj];
        }];
        if (foundPkgIndex != NSNotFound) {
            return [packages objectAtIndex:foundPkgIndex];
        } else {
            return nil;
        }
    }
}

- (void)conditionalItemsFrom:(NSArray *)items parent:(ConditionalItemMO *)parent manifest:(ManifestMO *)manifest context:(NSManagedObjectContext *)moc
{
    [items enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *condition = [(NSDictionary *)obj objectForKey:@"condition"];
        ConditionalItemMO *newConditionalItem = [NSEntityDescription insertNewObjectForEntityForName:@"ConditionalItem" inManagedObjectContext:moc];
        newConditionalItem.munki_condition = condition;
        newConditionalItem.manifest = manifest;
        newConditionalItem.originalIndexValue = idx;
        if (parent) {
            newConditionalItem.parent = parent;
            //newConditionalItem.joinedCondition = [NSString stringWithFormat:@"%@ - %@", parent.joinedCondition, newConditionalItem.munki_condition];
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ Nested conditional_item %lu --> Condition: %@", manifest.title, (unsigned long)idx, condition);
        } else {
            //newConditionalItem.joinedCondition = [NSString stringWithFormat:@"%@", newConditionalItem.munki_condition];
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ conditional_item %lu --> Condition: %@", manifest.title, (unsigned long)idx, condition);
        }
        
        NSArray *managedInstalls = [(NSDictionary *)obj objectForKey:@"managed_installs"];
        [managedInstalls enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ conditional_item --> managed_installs item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
            StringObjectMO *newManagedInstall = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newManagedInstall.title = (NSString *)obj;
            newManagedInstall.typeString = @"managedInstall";
            newManagedInstall.originalIndexValue = idx;
            [newConditionalItem addManagedInstallsObject:newManagedInstall];
        }];
        NSArray *managedUninstalls = [(NSDictionary *)obj objectForKey:@"managed_uninstalls"];
        [managedUninstalls enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ conditional_item --> managed_uninstalls item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
            StringObjectMO *newManagedUninstall = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newManagedUninstall.title = (NSString *)obj;
            newManagedUninstall.typeString = @"managedUninstall";
            newManagedUninstall.originalIndexValue = idx;
            [newConditionalItem addManagedUninstallsObject:newManagedUninstall];
        }];
        NSArray *managedUpdates = [(NSDictionary *)obj objectForKey:@"managed_updates"];
        [managedUpdates enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ conditional_item --> managed_updates item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
            StringObjectMO *newManagedUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newManagedUpdate.title = (NSString *)obj;
            newManagedUpdate.typeString = @"managedUpdate";
            newManagedUpdate.originalIndexValue = idx;
            [newConditionalItem addManagedUpdatesObject:newManagedUpdate];
        }];
        NSArray *optionalInstalls = [(NSDictionary *)obj objectForKey:@"optional_installs"];
        [optionalInstalls enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ conditional_item --> optional_installs item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
            StringObjectMO *newOptionalInstall = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newOptionalInstall.title = (NSString *)obj;
            newOptionalInstall.typeString = @"optionalInstall";
            newOptionalInstall.originalIndexValue = idx;
            [newConditionalItem addOptionalInstallsObject:newOptionalInstall];
        }];
        NSArray *includedManifests = [(NSDictionary *)obj objectForKey:@"included_manifests"];
        [includedManifests enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ conditional_item --> included_manifests item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
            StringObjectMO *newIncludedManifest = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
            newIncludedManifest.title = (NSString *)obj;
            newIncludedManifest.typeString = @"includedManifest";
            newIncludedManifest.originalIndexValue = idx;
            newIncludedManifest.indexInNestedManifestValue = idx;
            [newConditionalItem addIncludedManifestsObject:newIncludedManifest];
        }];
        
        // If there are nested conditional items, loop through them with this same function
        NSArray *conditionalItems = [(NSDictionary *)obj objectForKey:@"conditional_items"];
        if (conditionalItems) {
            [self conditionalItemsFrom:conditionalItems parent:newConditionalItem manifest:manifest context:moc];
        }
    }];
}


- (ManifestMO *)matchingManifestForString:(NSString *)title inMoc:(NSManagedObjectContext *)moc
{
    // Get all application objects for later use
    NSFetchRequest *getManifests = [[NSFetchRequest alloc] init];
    [getManifests setEntity:[NSEntityDescription entityForName:@"Manifest" inManagedObjectContext:moc]];
    [getManifests setReturnsObjectsAsFaults:NO];
    [getManifests setIncludesSubentities:NO];
    NSArray *manifests = [moc executeFetchRequest:getManifests error:nil];
    [getManifests release];
    
    NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title == %@", title];
    NSUInteger foundIndex = [manifests indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        return [titlePredicate evaluateWithObject:obj];
    }];
    
    if (foundIndex != NSNotFound) {
        return [manifests objectAtIndex:foundIndex];
    } else {
        return nil;
    }
}

-(void)main {
	@try {
		NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
		
		NSManagedObjectContext *moc = [[NSManagedObjectContext alloc] init];
		[moc setPersistentStoreCoordinator:[[self delegate] persistentStoreCoordinator]];
        [moc setUndoManager:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(contextDidSave:)
													 name:NSManagedObjectContextDidSaveNotification
												   object:moc];
		
		self.currentJobDescription = [NSString stringWithFormat:@"Reading manifest %@", self.fileName];
		if ([self.defaults boolForKey:@"debug"]) NSLog(@"Reading manifest %@", [self.sourceURL relativePath]);
		
        // Read the manifest dictionary from disk
		NSDictionary *manifestInfoDict = [NSDictionary dictionaryWithContentsOfURL:self.sourceURL];
		if (manifestInfoDict != nil) {
            
            // Get some needed NSURL properties all at once
            NSArray *filePropertiesToGet = [NSArray arrayWithObjects:
                                            NSURLNameKey, 
                                            NSURLCreationDateKey, 
                                            NSURLContentAccessDateKey, 
                                            NSURLContentModificationDateKey,
                                            nil];
            NSDictionary *manifestFileProperties = [self.sourceURL resourceValuesForKeys:filePropertiesToGet error:nil];
			NSString *filename = [manifestFileProperties objectForKey:NSURLNameKey];
            
            // Check if we already have a manifest with this name
            NSFetchRequest *request = [[NSFetchRequest alloc] init];
            NSEntityDescription *manifestEntityDescr = [NSEntityDescription entityForName:@"Manifest" inManagedObjectContext:moc];
			[request setEntity:manifestEntityDescr];
            [request setReturnsObjectsAsFaults:NO];
            [request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:
                                                            @"managedInstallsFaster",
                                                            @"managedUninstallsFaster",
                                                            @"managedUpdatesFaster",
                                                            @"optionalInstallsFaster",
                                                            nil]];
			
			NSPredicate *titlePredicate = [NSPredicate predicateWithFormat:@"title == %@", filename];
            
			[request setPredicate:titlePredicate];
            ManifestMO *manifest;
            NSArray *foundItems = [moc executeFetchRequest:request error:nil];
			if ([foundItems count] == 0) {
				manifest = [NSEntityDescription insertNewObjectForEntityForName:@"Manifest" inManagedObjectContext:moc];
                manifest.title = filename;
				manifest.manifestURL = self.sourceURL;
			} else {
				manifest = [foundItems objectAtIndex:0];
				if ([self.defaults boolForKey:@"debug"]) {
					NSLog(@"Found existing manifest %@", manifest.title);
				}
			}
			[request release];
			
            manifest.manifestDateCreated = [manifestFileProperties objectForKey:NSURLCreationDateKey];
            manifest.manifestDateLastOpened = [manifestFileProperties objectForKey:NSURLContentAccessDateKey];
            manifest.manifestDateModified = [manifestFileProperties objectForKey:NSURLContentModificationDateKey];
            
			manifest.originalManifest = manifestInfoDict;
            
			
            // =================================
			// Get "catalogs" items
            // =================================
			/*
             Left here as a reminder: Catalogs are processed with RelationshipScanner
             */
            
            
            // =================================
			// Get "managed_installs" items
			// =================================
            NSDate *startTime = [NSDate date];
            NSArray *managedInstalls = [manifestInfoDict objectForKey:@"managed_installs"];
            [managedInstalls enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ managed_installs item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
                StringObjectMO *newManagedInstall = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
                newManagedInstall.title = (NSString *)obj;
                newManagedInstall.typeString = @"managedInstall";
                newManagedInstall.originalIndexValue = idx;
                [manifest addManagedInstallsFasterObject:newManagedInstall];
                
                [pool drain];
            }];
            NSDate *now = [NSDate date];
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"Scanning managed_installs took %lf (ms)", [now timeIntervalSinceDate:startTime] * 1000.0);
            
            
            // =================================
			// Get "managed_uninstalls" items
			// =================================
            startTime = [NSDate date];
            NSArray *managedUninstalls = [manifestInfoDict objectForKey:@"managed_uninstalls"];
            [managedUninstalls enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ managed_uninstalls item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
                StringObjectMO *newManagedUninstall = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
                newManagedUninstall.title = (NSString *)obj;
                newManagedUninstall.typeString = @"managedUninstall";
                newManagedUninstall.originalIndexValue = idx;
                [manifest addManagedUninstallsFasterObject:newManagedUninstall];
                
                [pool drain];
            }];
            now = [NSDate date];
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"Scanning managed_uninstalls took %lf (ms)", [now timeIntervalSinceDate:startTime] * 1000.0);
            
            
            // =================================
			// Get "managed_updates" items
			// =================================
            startTime = [NSDate date];
            NSArray *managedUpdates = [manifestInfoDict objectForKey:@"managed_updates"];
            [managedUpdates enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ managed_updates item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
                StringObjectMO *newManagedUpdate = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
                newManagedUpdate.title = (NSString *)obj;
                newManagedUpdate.typeString = @"managedUpdate";
                newManagedUpdate.originalIndexValue = idx;
                [manifest addManagedUpdatesFasterObject:newManagedUpdate];
                
                [pool drain];
            }];
			now = [NSDate date];
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"Scanning managed_updates took %lf (ms)", [now timeIntervalSinceDate:startTime] * 1000.0);
            
            
            // =================================
			// Get "optional_installs" items
			// =================================
            startTime = [NSDate date];
            NSArray *optionalInstalls = [manifestInfoDict objectForKey:@"optional_installs"];
			[optionalInstalls enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
                if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ optional_installs item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
                StringObjectMO *newOptionalInstall = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
                newOptionalInstall.title = (NSString *)obj;
                newOptionalInstall.typeString = @"optionalInstall";
                newOptionalInstall.originalIndexValue = idx;
                [manifest addOptionalInstallsFasterObject:newOptionalInstall];
                
                [pool drain];
            }];
            now = [NSDate date];
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"Scanning optional_installs took %lf (ms)", [now timeIntervalSinceDate:startTime] * 1000.0);
            
            
            // =================================
			// Get "included_manifests" items
			// =================================
			NSArray *includedManifests = [manifestInfoDict objectForKey:@"included_manifests"];
            [includedManifests enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                if ([self.defaults boolForKey:@"debug"]) NSLog(@"%@ included_manifests item %lu --> Name: %@", manifest.title, (unsigned long)idx, obj);
                StringObjectMO *newIncludedManifest = [NSEntityDescription insertNewObjectForEntityForName:@"StringObject" inManagedObjectContext:moc];
                newIncludedManifest.title = (NSString *)obj;
                newIncludedManifest.typeString = @"includedManifest";
                newIncludedManifest.originalIndexValue = idx;
                newIncludedManifest.indexInNestedManifestValue = idx;
                [manifest addIncludedManifestsFasterObject:newIncludedManifest];
            }];
            
            
            // =================================
			// Get "conditional_items"
			// =================================
            startTime = [NSDate date];
			NSArray *conditionalItems = [manifestInfoDict objectForKey:@"conditional_items"];
            [self conditionalItemsFrom:conditionalItems parent:nil manifest:manifest context:moc];
            now = [NSDate date];
            if ([self.defaults boolForKey:@"debug"]) NSLog(@"Scanning conditional_items took %lf (ms)", [now timeIntervalSinceDate:startTime] * 1000.0);
			
		} else {
			NSLog(@"Can't read manifest file %@", [self.sourceURL relativePath]);
		}
		
		// Save the context, this causes main app delegate to merge new items
		NSError *error = nil;
		if (![moc save:&error]) {
			[NSApp presentError:error];
		}
		
        // Call back to our delegate, this causes app delegate to update the GUI
		if ([self.delegate respondsToSelector:@selector(scannerDidProcessPkginfo)]) {
			[self.delegate performSelectorOnMainThread:@selector(scannerDidProcessPkginfo) 
											withObject:nil
										 waitUntilDone:YES];
		}
		
		[[NSNotificationCenter defaultCenter] removeObserver:self
														name:NSManagedObjectContextDidSaveNotification
													  object:moc];
		[moc release], moc = nil;
		[pool release];
	}
	@catch(...) {
		// Do not rethrow exceptions.
	}
}


@end
