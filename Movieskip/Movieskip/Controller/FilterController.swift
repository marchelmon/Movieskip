//
//  FilterController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-16.
//

import UIKit


class FilterController: UIViewController {
    
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6176958476, green: 0.05836011096, blue: 0.1382402272, alpha: 1)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    } ()
    
    let releaseSliderView: UIView = {
        let view = UIView(backgroundColor: .white)
        return view
    } ()
    
    let genreSelectView: UIView = {
        let view = UIView(backgroundColor: .systemGreen)
        return view
    } ()
    
    let popularView: UIView = {
        let view = UIView(backgroundColor: .systemPink)
        return view
    } ()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        configureUI()
        
    }
    
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleReleaseYearChanged(sender: UISlider) {
        
    }
    
    @objc func handleCancel() {
        
    }
    
    @objc func handleSave() {
        
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        navigationItem.title = "Filter"
        navigationController?.navigationBar.tintColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleSave))
        
        
        let filterView = FilterView()
        
        let viewModel = FilterViewModel(filter: Filter())
        filterView.viewModel = viewModel
        
        view.addSubview(filterView)
        filterView.fillSuperview()
        
    }
    
}

//extension FilterController {
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return numberOfSections
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print(indexPath.section)
//        let cell = tableView.dequeueReusableCell(withIdentifier: resuseIdentifier, for: indexPath) as UITableViewCell
//
//        return cell
//    }
//}
