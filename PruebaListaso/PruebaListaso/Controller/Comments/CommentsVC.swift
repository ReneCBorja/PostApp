//
//  CommentsVC.swift
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

import Foundation

@objc class CommentsVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    

//    @objc public var idComment:String = ""
    let Conection = Conections()
    var comments: [Comment] = [] // Almacena los comentarios obtenidos
    private var filteredComments: [Comment] = []
    private var isFiltering: Bool = false
    private let searchBarView = SearchBarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSearchBar()
        let idComment = SharedManager.sharedInstance().sharedData
        self.getComments(idComment: idComment)
    }
    @IBOutlet weak var CommentTV: UITableView!
    
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredComments.count : comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellCommentsVC", for: indexPath) as! CellCommentsVC
        cell.CommentsContentView.layer.cornerRadius = 5
        cell.CommentsContentView.layer.borderWidth = 0.5
        cell.CommentsContentView.layer.shadowColor = UIColor.gray.cgColor
        cell.CommentsContentView.layer.shadowOpacity = 1
        cell.CommentsContentView.layer.shadowOffset = CGSize(width: 0 , height:2)
        cell.CommentsContentView.layer.shadowRadius = 5
        let comment = isFiltering ? filteredComments[indexPath.row] : comments[indexPath.row]
        
        if comment.id % 2 == 0 {
            cell.Content.frame.origin.x = 5
            
        }
        cell.lblContent.text = comment.body
        cell.lblContent.adjustsFontSizeToFitWidth = true
        cell.lblemail.text = comment.email
        return cell
    }
    
    // MARK: - Filtering Logic
       private func filterComments(for searchText: String) {
           guard !searchText.isEmpty else {
               isFiltering = false
               self.CommentTV.reloadData()
               return
           }
           
           isFiltering = true
           filteredComments = comments.filter { comment in
               comment.name.lowercased().contains(searchText.lowercased()) ||
               comment.body.lowercased().contains(searchText.lowercased())
           }
           self.CommentTV.reloadData()
       }
    
    private func setupSearchBar() {
          searchBarView.searchBar.delegate = self
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.CommentTV.frame.width, height: 60))
          headerView.addSubview(searchBarView)
          searchBarView.translatesAutoresizingMaskIntoConstraints = false

          NSLayoutConstraint.activate([
              searchBarView.topAnchor.constraint(equalTo: headerView.topAnchor),
              searchBarView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
              searchBarView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
              searchBarView.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
          ])

        self.CommentTV.tableHeaderView = headerView
      }
    
    func getComments(idComment: String) {
           Conection.fetchData(from: "/posts/\(idComment)/comments", responseType: [Comment].self) { [weak self] result in
               guard let self = self else { return }

               DispatchQueue.main.async {
                   switch result {
                   case .success(let comments):
                   //    print("Comentarios recibidos: \(comments.count)")
                       self.comments = comments
                       self.CommentTV.reloadData() 
                   case .failure(let error):
                    //   print("Error al obtener comentarios: \(error.localizedDescription)")
                       AlertHelper.showAlert(on: self, withMessage: error.localizedDescription)
                   }
               }
           }
       }
    
}
// MARK: - UISearchBarDelegate
extension CommentsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterComments(for: searchText)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isFiltering = false
        self.CommentTV.reloadData()
    }
}
