//
//  MovieTable.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-15.
//

import UIKit

private let cellIdentifier = "MovieCell"

class MovieTable: UITableView {
    
    //MARK: - Properties
    
    var movies: [Movie]! {
        didSet{ loadData() }
    }
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        separatorStyle = .none
        backgroundColor = .systemPink
        alpha = 1
    }
    
    func loadData() {
        print("Movies were added to collection")
    }
    
    
}


extension MovieTable: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell

        return cell
    }
    
    
}
