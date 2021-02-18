//
//  FilterController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-16.
//

import UIKit

private let cellIdentifier = "FilterCell"

class FilterController: UITableViewController {
        
    var headerView = FilterView()
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
        
    }
    
    
    //MARK: - Actions
    
    @objc func handleReleaseYearChanged(sender: UISlider) {
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        let filter = headerView.viewModel.filter
    
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Filter"
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableHeaderView = headerView
        
        headerView.viewModel = FilterViewModel(filter: Filter())
        
    }
    
    func setFilter() {
        
    }
    
    func addGenreToFilter(pressedGenre: String) -> Bool {
        
        let genreFromName = getGenreByName(genreName: pressedGenre)
        let genresArray = headerView.viewModel.filter.genres

        if genresArray.count == 0 {
            headerView.viewModel.filter.genres.append(genreFromName)
            return true
        }
        
        for (index, genre) in genresArray.enumerated() {
            if genre.name == pressedGenre {
                headerView.viewModel.filter.genres.remove(at: index)
                return false
            }
            if index == genresArray.endIndex - 1 {
                headerView.viewModel.filter.genres.append(genreFromName)
                return true
            }
        }
        return false
    }
    
}



//MARK: - UITableViewDelegate

extension FilterController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            if let cell = tableView.cellForRow(at: indexPath) {
                
                guard let genreName = cell.textLabel?.text else { return }
                
                cell.accessoryType = addGenreToFilter(pressedGenre: genreName) ? .checkmark : .none
                
                print("Filter genre count: \(headerView.viewModel.filter.genres.count)")
                
            }
        }
    }
    
}

//MARK: - UITableViewDataSource

extension FilterController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TMDB_GENRES.count + 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as UITableViewCell
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        if indexPath.row == 0 {
            cell.textLabel?.text = "Genres"
        } else {
            cell.textLabel?.text = TMDB_GENRES[indexPath.row - 1].name
        }
        return cell
    }
    
}
