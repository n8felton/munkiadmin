// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ManifestDirectoryMO.m instead.

#import "_ManifestDirectoryMO.h"

const struct ManifestDirectoryMOAttributes ManifestDirectoryMOAttributes = {
	.originalURL = @"originalURL",
};

const struct ManifestDirectoryMORelationships ManifestDirectoryMORelationships = {
};

const struct ManifestDirectoryMOFetchedProperties ManifestDirectoryMOFetchedProperties = {
	.childManifests = @"childManifests",
};

@implementation ManifestDirectoryMOID
@end

@implementation _ManifestDirectoryMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ManifestDirectory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ManifestDirectory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ManifestDirectory" inManagedObjectContext:moc_];
}

- (ManifestDirectoryMOID*)objectID {
	return (ManifestDirectoryMOID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic originalURL;








@dynamic childManifests;




@end
