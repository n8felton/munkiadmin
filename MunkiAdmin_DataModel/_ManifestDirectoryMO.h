// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ManifestDirectoryMO.h instead.

#import <CoreData/CoreData.h>
#import "ManifestSourceListItemMO.h"

extern const struct ManifestDirectoryMOAttributes {
	 NSString *originalURL;
} ManifestDirectoryMOAttributes;

extern const struct ManifestDirectoryMORelationships {
} ManifestDirectoryMORelationships;

extern const struct ManifestDirectoryMOFetchedProperties {
	 NSString *childManifests;
} ManifestDirectoryMOFetchedProperties;


@class NSObject;

@interface ManifestDirectoryMOID : NSManagedObjectID {}
@end

@interface _ManifestDirectoryMO : ManifestSourceListItemMO {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ManifestDirectoryMOID*)objectID;




@property (nonatomic, retain) id originalURL;


//- (BOOL)validateOriginalURL:(id*)value_ error:(NSError**)error_;





@property (nonatomic, readonly) NSArray *childManifests;


@end

@interface _ManifestDirectoryMO (CoreDataGeneratedAccessors)

@end

@interface _ManifestDirectoryMO (CoreDataGeneratedPrimitiveAccessors)


- (id)primitiveOriginalURL;
- (void)setPrimitiveOriginalURL:(id)value;




@end
