//
//  FilterController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-16.
//

import UIKit

private let cellIdentifier = "FilterCell"

protocol FilterControllerDelegate: class {
    func filterController(controller: FilterController, wantsToUpdateFilter filter: Filter)
}

class FilterController: UITableViewController {
        
    weak var delegate: FilterControllerDelegate?
    
    var filterView: FilterView
    
    //MARK: - Lifecycle
    
    init(filterView: FilterView) {
        self.filterView = filterView
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
        
        let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
        sceneDelegate.printShit()
    }
    
    
    //MARK: - Actions
    
    @objc func handleReleaseYearChanged(sender: UISlider) {
        
    }
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleSave() {
        if filterView.viewModel.filter.minYear > filterView.viewModel.filter.maxYear {
            filterView.viewModel.filter.minYear = 2010
            filterView.viewModel.filter.maxYear = 2021
        }
        delegate?.filterController(controller: self, wantsToUpdateFilter: filterView.viewModel.filter)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Filter"
        navigationController?.navigationBar.tintColor = .black
        tableView.separatorStyle = .none
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        filterView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 270)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.tableHeaderView = filterView
                
    }
    
    func addGenreToFilter(pressedGenre: String) -> Bool {
        
        let genreFromName = getGenreByName(genreName: pressedGenre)
        let genresArray = filterView.viewModel.filter.genres

        if genresArray.count == 0 {
            filterView.viewModel.filter.genres.append(genreFromName)
            return true
        }
        
        for (index, genre) in genresArray.enumerated() {
            if genre.name == pressedGenre {
                filterView.viewModel.filter.genres.remove(at: index)
                return false
            }
            if index == genresArray.endIndex - 1 {
                filterView.viewModel.filter.genres.append(genreFromName)
                return true
            }
        }
        return false
    }
    
    func genreFoundInFilter(genreName: String) -> Bool {
        for genre in filterView.viewModel.filter.genres {
            if genre.name == genreName {
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
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
            cell.textLabel?.text = "Genre"
        } else {
            let genreName = TMDB_GENRES[indexPath.row - 1].name
            cell.textLabel?.text = genreName
            cell.accessoryType = genreFoundInFilter(genreName: genreName) ? .checkmark : .none
        }
        return cell
    }
    
}
