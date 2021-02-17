//
//  FilterView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-16.
//

import UIKit

class FilterView: UIView {
    
    var viewModel: FilterViewModel! {
        didSet { configure() }
    }
        
    var minYearLabel = UILabel()
    var maxYearLabel = UILabel()
    
    lazy var minYearSlider = UISlider()
    lazy var maxYearSlider = UISlider()
    
    let popularText: UILabel = {
        let label = UILabel()
        label.text = "Popular movies only"
        return label
    }()
    
    lazy var popularToggle: UISwitch = {
        let toggle = UISwitch()
        toggle.addTarget(self, action: #selector(handleTogglePopular), for: .touchUpInside)
        
        return toggle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                
        
        addSubview(minYearLabel)
        minYearLabel.centerX(inView: self)
        minYearLabel.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 30, paddingLeft: 20)

        addSubview(minYearSlider)
        minYearSlider.anchor(top: minYearLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingRight: 25)

        addSubview(maxYearLabel)
        maxYearLabel.anchor(top: minYearSlider.bottomAnchor, left: leftAnchor, paddingTop: 20, paddingLeft: 20)

        addSubview(maxYearSlider)
        maxYearSlider.anchor(top: maxYearLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 30, paddingRight: 25)

        
        let popularStack = UIStackView(arrangedSubviews: [popularText, popularToggle])
        
        addSubview(popularStack)
        popularStack.anchor(top: maxYearSlider.bottomAnchor, paddingTop: 30)
        
        popularText.anchor(left: leftAnchor, paddingLeft: 15)
        popularToggle.anchor(right: rightAnchor, paddingRight: 15)
                
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handleTogglePopular(sender: UISwitch) {
        print("TOGGLED POPULAR")
        print(sender.isOn)
    }
    
    
    //MARK: - Helpers
    
    func configure() {
                
        minYearLabel.text = viewModel.minYearText(forValue: viewModel.minYearSliderValue)
        maxYearLabel.text = viewModel.maxYearText(forValue: viewModel.maxYearSliderValue)
        
        minYearSlider.setValue(viewModel.minYearSliderValue, animated: true)
        maxYearSlider.setValue(viewModel.maxYearSliderValue, animated: true)
    
        popularToggle.setOn(viewModel.popular, animated: true)
        
    }
    
    
}



