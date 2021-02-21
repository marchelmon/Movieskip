//
//  DetailsViewController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-20.
//

import UIKit

class DetailsController: UIViewController {
    
    //MARK: - Properties
    
    private var movie: Movie?
    
    //MARK: - Lifecycle
    
    init(movie: Movie) {
        self.movie = movie
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
