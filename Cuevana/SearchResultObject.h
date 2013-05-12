//
//  MovieResultObject.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 10/30/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    SearchResultObjectTypeMovie,
    SearchResultObjectTypeSerie,
    SearchResultObjectTypeOther,
}SearchResultObjectType;

@interface SearchResultObject : NSObject

@property(nonatomic,strong) NSNumber *resultId;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong) NSString *title;
@property(nonatomic,strong) NSString *info;
@property(nonatomic,assign) NSInteger year;
@property(nonatomic,assign,getter = isPlayable) BOOL playable;
@property(nonatomic,assign) SearchResultObjectType type;

+ (instancetype)searchResultObjectFromDictionary:(NSDictionary*)object;

- (void)fillWithDictionary:(NSDictionary*)object;

- (NSURL*)urlThumbnail;
- (NSString*)typeString;
@end
