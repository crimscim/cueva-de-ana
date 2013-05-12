//
//  SearchCell.m
//  Cuevana
//
//  Created by Camilo Vera Bezmalinovic on 11/14/12.
//  Copyright (c) 2012 Camilo Vera Bezmalinovic. All rights reserved.
//

#import "SearchCell.h"

static CGFloat __cellHeight = 0.0;
static NSString *__cellIdentifier = nil;

@implementation SearchCell

+ (id)cell
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SearchCell" owner:self options:nil];
    
    SearchCell *cell = (SearchCell*)[nib objectAtIndex:0];
    
    nib = nil;
    
    if (__cellHeight < 0.1)
    {
        __cellHeight = cell.frame.size.height;
    }
    
    if (__cellIdentifier == nil)
    {
        __cellIdentifier = [[NSString alloc] initWithString:cell.reuseIdentifier];
    }

    [cell createBackground];
    
    return cell;
}

+ (CGFloat)cellHeight
{
    if (__cellHeight < 0.1)
    {
        [SearchCell cell];
    }
    return __cellHeight;
}


+ (NSString*)cellIdentifier
{
    if (__cellIdentifier == nil)
    {
        [SearchCell cell];
    }
    return __cellIdentifier;
}


- (void)createBackground
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:self.frame];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIImage *stretchableImage = [[UIImage imageNamed:@"cell-search-bg.png"] stretchableImageWithLeftCapWidth:160.0 topCapHeight:1];
    backgroundView.image = stretchableImage;
    
    self.backgroundView = backgroundView;
}

@end
