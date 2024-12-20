//
//  CellPostVC.h
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CellPostVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *PostContentView;
@property (weak, nonatomic) IBOutlet UILabel *lblTittle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIButton *btnShowGalery;
@property (weak, nonatomic) IBOutlet UIButton *btnShowComments;


@property (nonatomic, copy) void(^showGaleryTapHandler)(void);
@property (nonatomic, copy) void(^showCommentsTapHandler)(void);

@end

NS_ASSUME_NONNULL_END
