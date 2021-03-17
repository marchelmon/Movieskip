//
//  MovieTable.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-15.
//

import UIKit

private let cellIdentifier = "MovieCell"

class MovieTable: UIView {
    
    //MARK: - Properties
    
    var movies = [Movie]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemGroupedBackground
        table.layer.cornerRadius = 5
        table.separatorStyle = .none
        return table
    }()
    
    //MARK: - Lifecycle
    

    
    //MARK: - Helpers
    
    func configureUI() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemPink
    }
    
}


extension MovieTable: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WatchlistTableCell

        print(indexPath.row)
        
        cell.movie = movies[indexPath.row]
        
        return cell
    }
    
    
}
