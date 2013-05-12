//
//  EpisodeResultObject.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 10/31/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "EpisodeResultObject.h"

@implementation EpisodeResultObject

- (void)fillWithDictionary:(NSDictionary *)object
{
    self.resultId     = object[@"id"];
    self.hd            = [object[@"hd"] boolValue];
    self.episodeNumber = [object[@"num"] integerValue];
    self.rate          = [object[@"rate"] floatValue];
    self.title         = object[@"tit"];
    self.url           = [NSURL URLWithString:object[@"url"]];
}
-(NSString *)description
{
    
    NSDictionary *data;
    data = @{
    @"hd":@(self.hd),
    @"url":self.url,
    @"title":self.title,
    @"id":self.resultId,
    @"number":@(self.episodeNumber),
    @"season":@(self.seasonNumber),
    @"rate":@(self.rate),
    @"searchResultObject":self.searchResultObject
    };
    
    return [NSString stringWithFormat:@"EpisodeResultObject <%p> : %@",self,data];
}
@end
