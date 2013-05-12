//
//  SearchModel.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 5/11/13.
//  Copyright (c) 2013 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchModelDelegate;

@interface SearchModel : NSObject
@property(nonatomic,strong) NSArray *arraySearchResults;
@property(nonatomic,weak) id <SearchModelDelegate> delegate;

- (void)search:(NSString*)text;

@end

@protocol SearchModelDelegate <NSObject>
-(void)searchModel:(SearchModel*)model didFinishLoading:(NSArray*)results;
@end
