//
//  MatchingResultsView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-21.
//

import UIKit

class MatchingResultsView: UIView {

    let sceneDelegate = UIApplication.shared.connectedScenes.first!.delegate as! SceneDelegate
    
    
    private let backButton: UIButton = {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50)
        let image = UIImage(systemName: "arrow.backward", withConfiguration: imageConfig)?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let button = UIButton(type: .system)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleGoBack), for: .touchUpInside)
        return button
    }()
    
    private let watchlistResultsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("* VS *", for: .normal)
        button.setTitleColor(MAIN_COLOR, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showWatchlistResults), for: .touchUpInside)
        return button
    }()

    private let excludeResultsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("* VS X", for: .normal)
        button.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addTarget(self, action: #selector(showExcludeResults), for: .touchUpInside)
        return button
    }()
    
    
    
    private lazy var watchlistResultsTable = MovieTable()
    private lazy var excludeResultsTable = MovieTable()


    override init(frame: CGRect) {
        super.init(frame: frame)
        
        excludeResultsTable.isHidden = true
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Actions

    @objc func showWatchlistResults() {
        excludeResultsTable.isHidden = true
        watchlistResultsTable.isHidden = false

        watchlistResultsButton.setTitleColor(MAIN_COLOR, for: .normal)
        excludeResultsButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }

    @objc func showExcludeResults() {
        watchlistResultsTable.isHidden = true
        excludeResultsTable.isHidden = false
        
        excludeResultsButton.setTitleColor(MAIN_COLOR, for: .normal)
        watchlistResultsButton.setTitleColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), for: .normal)
    }
    
    
    @objc func handleGoBack() {
        //delegate?.bla()
    }
    
    
    //MARK: - Helpers
    
    func configureUI() {
        addSubview(backButton)
        backButton.anchor(top: safeAreaLayoutGuide.topAnchor, left: leftAnchor, paddingTop: 30, paddingLeft: 20)
        
        let topButtonStack = UIStackView(arrangedSubviews: [UIView(), watchlistResultsButton, excludeResultsButton, UIView()])
        topButtonStack.backgroundColor = .white
        topButtonStack.distribution = .equalSpacing
        
        addSubview(topButtonStack)
        topButtonStack.anchor(top: backButton.bottomAnchor, left: leftAnchor, right: rightAnchor, width: frame.width, height: 70)
        
        addSubview(watchlistResultsTable)
        watchlistResultsTable.anchor(top: topButtonStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 50)
        
        addSubview(excludeResultsTable)
        excludeResultsTable.anchor(top: topButtonStack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 50)
        
    }
    
}
