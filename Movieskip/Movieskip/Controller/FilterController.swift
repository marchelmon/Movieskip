//
//  FilterController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-16.
//

import UIKit


class FilterController: UIViewController {
    
    private let numberOfSections = 3
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Dismiss", for: .normal)
        button.tintColor = #colorLiteral(red: 0.6176958476, green: 0.05836011096, blue: 0.1382402272, alpha: 1)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    } ()
    
    let releaseSliderView: UIView = {
        let view = UIView(backgroundColor: .systemBlue)
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

        let stack = UIStackView(arrangedSubviews: [releaseSliderView, ])
        
        view.addSubview(releaseSliderView)
        
        releaseSliderView.fillSuperview()
        
//        dismissButton.setDimensions(height: 100, width: 100)
//        dismissButton.anchor(top: view.topAnchor, paddingTop: 100)
        
        
        
    }
    
    
    //MARK: - Actions
    
    @objc func handleDismiss() {
        dismiss(animated: true, completion: nil)
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
