// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ManifestSourceListItemMO.m instead.

#import "_ManifestSourceListItemMO.h"

const struct ManifestSourceListItemMOAttributes ManifestSourceListItemMOAttributes = {
	.isGroupItem = @"isGroupItem",
	.originalIndex = @"originalIndex",
	.title = @"title",
	.type = @"type",
};

const struct ManifestSourceListItemMORelationships ManifestSourceListItemMORelationships = {
	.children = @"children",
	.manifests = @"manifests",
	.parent = @"parent",
};

const struct ManifestSourceListItemMOFetchedProperties ManifestSourceListItemMOFetchedProperties = {
};

@implementation ManifestSourceListItemMOID
@end

@implementation _ManifestSourceListItemMO

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ManifestSourceListItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ManifestSourceListItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ManifestSourceListItem" inManagedObjectContext:moc_];
}

- (ManifestSourceListItemMOID*)objectID {
	return (ManifestSourceListItemMOID*)[super objectID];
}

+ (NSSet *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"isGroupItemValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isGroupItem"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}
	if ([key isEqualToString:@"originalIndexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"originalIndex"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
	}

	return keyPaths;
}




@dynamic isGroupItem;



- (BOOL)isGroupItemValue {
	NSNumber *result = [self isGroupItem];
	return [result boolValue];
}

- (void)setIsGroupItemValue:(BOOL)value_ {
	[self setIsGroupItem:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsGroupItemValue {
	NSNumber *result = [self primitiveIsGroupItem];
	return [result boolValue];
}

- (void)setPrimitiveIsGroupItemValue:(BOOL)value_ {
	[self setPrimitiveIsGroupItem:[NSNumber numberWithBool:value_]];
}





@dynamic originalIndex;



- (int32_t)originalIndexValue {
	NSNumber *result = [self originalIndex];
	return [result intValue];
}

- (void)setOriginalIndexValue:(int32_t)value_ {
	[self setOriginalIndex:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveOriginalIndexValue {
	NSNumber *result = [self primitiveOriginalIndex];
	return [result intValue];
}

- (void)setPrimitiveOriginalIndexValue:(int32_t)value_ {
	[self setPrimitiveOriginalIndex:[NSNumber numberWithInt:value_]];
}





@dynamic title;






@dynamic type;






@dynamic children;

	
- (NSMutableSet*)childrenSet {
	[self willAccessValueForKey:@"children"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"children"];
  
	[self didAccessValueForKey:@"children"];
	return result;
}
	

@dynamic manifests;

	
- (NSMutableSet*)manifestsSet {
	[self willAccessValueForKey:@"manifests"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"manifests"];
  
	[self didAccessValueForKey:@"manifests"];
	return result;
}
	

@dynamic parent;

	






@end
