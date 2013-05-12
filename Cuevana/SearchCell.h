//
//  SearchCell.h
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 11/14/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *labelName;
@property (strong, nonatomic) IBOutlet UILabel *labelType;
@property (strong, nonatomic) IBOutlet UILabel *labelYear;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewThumbnail;

+ (id)cell;
+ (CGFloat)cellHeight;
+ (NSString*)cellIdentifier;
@end
