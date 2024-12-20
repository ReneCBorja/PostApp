//
//  CellPostVCTableViewCell.m
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

#import "CellPostVC.h"

@implementation CellPostVC

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    
    return self;
}

- (IBAction)btnShowGalery:(UIButton *)sender
{
    self.showGaleryTapHandler();

}

- (IBAction)commentButtonTapped:(UIButton *)sender
{
    self.showCommentsTapHandler();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
