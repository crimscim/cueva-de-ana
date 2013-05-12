//
//  SearchModel.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/11/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "SearchModel.h"
#import "AFNetworking.h"
#import "SearchResultObject.h"
#import "AFJSONRequestOperation.h"
#import "CuevanaConstants.h"
#import "SBJson.h"

@interface SearchModel ()
@property (nonatomic,strong) AFHTTPClient *httpClient;
@end

@implementation SearchModel

- (id)init
{
    self = [super init];
    if (self)
    {
        self.httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:kCuevanaBaseURL]];
    }
    return self;
}

- (void)search:(NSString*)text
{
    [self.httpClient cancelAllHTTPOperationsWithMethod:@"POST" path:kCuevanaSearchPath];
    
    NSMutableURLRequest *request = [self.httpClient requestWithMethod:@"POST"
                                                                 path:kCuevanaSearchPath
                                                           parameters:@{@"q":text}];
    

    AFHTTPRequestOperation *requestOp = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    [requestOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSArray *arrayJson = [operation.responseString JSONValue];
        
        NSMutableArray *arrayResult = [NSMutableArray array];
        
        for (NSDictionary *object in arrayJson)
        {
            [arrayResult addObject:[SearchResultObject searchResultObjectFromDictionary:object]];
        }
        
        self.arraySearchResults = arrayResult;
        
        [self.delegate searchModel:self didFinishLoading:self.arraySearchResults];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        self.arraySearchResults = nil;
        [self.delegate searchModel:self didFinishLoading:self.arraySearchResults];
    }];


    [self.httpClient enqueueHTTPRequestOperation:requestOp];
}

@end
