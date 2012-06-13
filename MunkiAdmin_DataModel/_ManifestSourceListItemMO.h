// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ManifestSourceListItemMO.h instead.

#import <CoreData/CoreData.h>


extern const struct ManifestSourceListItemMOAttributes {
	 NSString *isGroupItem;
	 NSString *originalIndex;
	 NSString *title;
	 NSString *type;
} ManifestSourceListItemMOAttributes;

extern const struct ManifestSourceListItemMORelationships {
	 NSString *children;
	 NSString *manifests;
	 NSString *parent;
} ManifestSourceListItemMORelationships;

extern const struct ManifestSourceListItemMOFetchedProperties {
} ManifestSourceListItemMOFetchedProperties;

@class ManifestSourceListItemMO;
@class ManifestMO;
@class ManifestSourceListItemMO;






@interface ManifestSourceListItemMOID : NSManagedObjectID {}
@end

@interface _ManifestSourceListItemMO : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (ManifestSourceListItemMOID*)objectID;




@property (nonatomic, retain) NSNumber* isGroupItem;


@property BOOL isGroupItemValue;
- (BOOL)isGroupItemValue;
- (void)setIsGroupItemValue:(BOOL)value_;

//- (BOOL)validateIsGroupItem:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSNumber* originalIndex;


@property int32_t originalIndexValue;
- (int32_t)originalIndexValue;
- (void)setOriginalIndexValue:(int32_t)value_;

//- (BOOL)validateOriginalIndex:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString* title;


//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) NSString* type;


//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, retain) NSSet* children;

- (NSMutableSet*)childrenSet;




@property (nonatomic, retain) NSSet* manifests;

- (NSMutableSet*)manifestsSet;




@property (nonatomic, retain) ManifestSourceListItemMO* parent;

//- (BOOL)validateParent:(id*)value_ error:(NSError**)error_;





@end

@interface _ManifestSourceListItemMO (CoreDataGeneratedAccessors)

- (void)addChildren:(NSSet*)value_;
- (void)removeChildren:(NSSet*)value_;
- (void)addChildrenObject:(ManifestSourceListItemMO*)value_;
- (void)removeChildrenObject:(ManifestSourceListItemMO*)value_;

- (void)addManifests:(NSSet*)value_;
- (void)removeManifests:(NSSet*)value_;
- (void)addManifestsObject:(ManifestMO*)value_;
- (void)removeManifestsObject:(ManifestMO*)value_;

@end

@interface _ManifestSourceListItemMO (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveIsGroupItem;
- (void)setPrimitiveIsGroupItem:(NSNumber*)value;

- (BOOL)primitiveIsGroupItemValue;
- (void)setPrimitiveIsGroupItemValue:(BOOL)value_;




- (NSNumber*)primitiveOriginalIndex;
- (void)setPrimitiveOriginalIndex:(NSNumber*)value;

- (int32_t)primitiveOriginalIndexValue;
- (void)setPrimitiveOriginalIndexValue:(int32_t)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (NSMutableSet*)primitiveChildren;
- (void)setPrimitiveChildren:(NSMutableSet*)value;



- (NSMutableSet*)primitiveManifests;
- (void)setPrimitiveManifests:(NSMutableSet*)value;



- (ManifestSourceListItemMO*)primitiveParent;
- (void)setPrimitiveParent:(ManifestSourceListItemMO*)value;


@end
