//
//  MovieTable.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-15.
//

import UIKit

private let cellIdentifier = "MovieCell"

protocol MovieTableDelegate: class {
    func tablePresentMovieDetails(movie: Movie)
}

class MovieTable: UIView {
    
    //MARK: - Properties
    
    weak var delegate: MovieTableDelegate?
    
    var movies: [Movie]! {
        didSet{ loadData() }
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .white
        table.separatorStyle = .none
        return table
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        movies = []
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WatchlistTableCell.self, forCellReuseIdentifier: cellIdentifier)

        addSubview(tableView)
        tableView.fillSuperview()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions
    
    func loadData() {
        tableView.reloadData()
    }
    
}


extension MovieTable: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = movies[indexPath.row]
        
        print(movie.title)
        
        delegate?.tablePresentMovieDetails(movie: movie)
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! WatchlistTableCell
        let movie = movies[indexPath.row]
        
        cell.poster.sd_setImage(with: movie.posterPath)
        cell.movieTitle.text = movie.title
        cell.rating.text = String(movie.rating)
                
        return cell
    }
    
    
}
