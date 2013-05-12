//
//  MovieResultObject.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 10/30/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "SearchResultObject.h"
#import "CuevanaConstants.h"

@implementation SearchResultObject

+ (instancetype)searchResultObjectFromDictionary:(NSDictionary*)object
{
    SearchResultObject * resultObject = [[SearchResultObject alloc] init];
    [resultObject fillWithDictionary:object];
    return resultObject;
}

- (void)fillWithDictionary:(NSDictionary*)object
{
    self.resultId = object[@"id"];
    self.year     = [object[@"year"] integerValue];
    self.playable = [object[@"playable"] boolValue];
    self.title    = object[@"tit"];
    self.info     = object[@"info"];
    self.url      = [NSURL URLWithString:object[@"url"]];
}

- (NSURL*)urlThumbnail
{
    NSString *urlString = [NSString stringWithFormat:kCuevanaThumbnailURL,self.resultId];
    return [NSURL URLWithString:urlString];
}
- (NSString*)typeString
{
    NSString *type = nil;
    switch (self.type)
    {
        case SearchResultObjectTypeMovie:
            type = @"Movie";
            break;
        case SearchResultObjectTypeSerie:
            type = @"Serie";
            break;
        default:
            type = @"Other";
    }
    return type;
}

//parse url looking for type
-(void)setUrl:(NSURL *)url
{
    _url = url;
    
    NSRange rangeMovie = [url.absoluteString rangeOfString:@"/peliculas/"];
    if (rangeMovie.location != NSNotFound)
    {
        self.type = SearchResultObjectTypeMovie;
        return;
    }
    
    NSRange rangeSerie = [url.absoluteString rangeOfString:@"/series/"];
    if (rangeSerie.location != NSNotFound)
    {
        self.type = SearchResultObjectTypeSerie;
        return;
    }
    
    self.type = SearchResultObjectTypeOther;

}
-(NSString *)description
{
    
    NSDictionary *data;
    data = @{
    @"id":self.resultId,
    @"url":self.url,
    @"title":self.title,
    @"info":self.info,
    @"year":@(self.year),
    @"thumbnail":self.urlThumbnail,
    @"type":self.typeString
    };
    
    return [NSString stringWithFormat:@"SerchResultObject <%p> : %@",self,data];
}
@end
