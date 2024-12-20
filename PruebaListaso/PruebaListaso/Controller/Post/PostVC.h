//
//  PostVC.h
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

#import <UIKit/UIKit.h>


@interface PostVC : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating>
@property (weak, nonatomic) IBOutlet UITableView *PostTV;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

