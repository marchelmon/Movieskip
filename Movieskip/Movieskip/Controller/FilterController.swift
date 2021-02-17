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
    
}



//MARK: - UITableViewDelegate

extension FilterController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row != 0 {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = cell.accessoryType == .none ? .checkmark : .none
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
