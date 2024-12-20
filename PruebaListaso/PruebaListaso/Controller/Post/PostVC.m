//
//  PostVC.m
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

#import "PostVC.h"
#import "CellPostVC.h"
#import "PruebaListaso-Swift.h"
#import "SharedManager.h"

@interface PostVC() <UISearchBarDelegate> {
    NSMutableArray* tableData;
    NSMutableArray* filteredData;
    BOOL isFiltering;
}
@end

@implementation PostVC

- (void)viewDidLoad {
    [self initConfig];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getRequest:@""];
    
}

- (void)initConfig {
    tableData = [NSMutableArray new];
    filteredData = [NSMutableArray new];
    isFiltering = NO;
    
    // Configurar la SearchBar
    self.searchBar.placeholder = @"Buscar...";
    self.searchBar.delegate = self;
    self.searchBar.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark - TableView DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (isFiltering) {
        return filteredData.count; // Mostrar datos filtrados
    } else {
        return tableData.count; // Mostrar todos los datos
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"CellPostVC";
    CellPostVC *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    NSMutableDictionary *data = [NSMutableDictionary new];
    if (isFiltering) {
        data = filteredData[indexPath.row];
    } else{
       data = tableData[indexPath.row];
    }
  
    cell.PostContentView.layer.cornerRadius = 5.0;
    cell.PostContentView.layer.borderWidth = 0.5;
    cell.lblTittle.text = [NSString stringWithFormat:@"%@", data[@"title"]];
    cell.lblContent.text = [NSString stringWithFormat:@"%@", data[@"body"]];
    cell.lblTittle.adjustsFontSizeToFitWidth = YES;
    cell.lblContent.adjustsFontSizeToFitWidth = YES;
    
    cell.showCommentsTapHandler = ^{
        [SharedManager sharedInstance].sharedData = [NSString stringWithFormat:@"%@", data[@"id"]];
    };
    cell.showGaleryTapHandler = ^{
        [SharedManager sharedInstance].sharedData = [NSString stringWithFormat:@"%@", data[@"id"]];
    };
    
    return cell;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
  
        if (searchText.length == 0) {
            // Si no hay texto en la barra de búsqueda, mostramos todos los datos originales
            filteredData = [NSMutableArray arrayWithArray:tableData];
            isFiltering = NO;
        } else {
            // Filtrar los datos de acuerdo al texto introducido
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ OR body CONTAINS[c] %@", searchText, searchText];
            isFiltering = YES;
            // Asignar los resultados filtrados a `filteredData`
            filteredData = [NSMutableArray arrayWithArray:[tableData filteredArrayUsingPredicate:predicate]];
        }
        // Recargar la tabla para reflejar los datos filtrados
        [self.PostTV reloadData];
   
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    isFiltering = NO;
    [searchBar resignFirstResponder];
    [self.PostTV reloadData];
}

#pragma mark - WebService

- (void)getRequest:(NSString *)resource {
    NSString *urlBase = @"https://jsonplaceholder.typicode.com/posts";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", urlBase, resource]]];
    [request setHTTPMethod:@"GET"];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error.localizedDescription);
            [AlertHelper showAlertOn:self withMessage:[NSString stringWithFormat:@"%@", error.localizedDescription]];
            return;
        }
        NSError *jsonError = nil;
        NSArray *array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
        if (!jsonError) {
            self->tableData = [NSMutableArray arrayWithArray:array];
            self->filteredData = self->tableData;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.PostTV reloadData];
            });
        }
    }] resume];
}

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController { 
    
}



@end
