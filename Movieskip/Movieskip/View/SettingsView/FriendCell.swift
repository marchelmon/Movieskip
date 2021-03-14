//
//  FriendCell.swift
//  Movieskip
//
//  Created by marchelmon on 2021-03-02.
//

import UIKit

class FriendCell: UITableViewCell {
    
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = MAIN_COLOR
        return label
    }()
    
    let watchlistCount:  UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
 
    let excludeCount:  UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let removeFriendButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "person.fill.badge.minus", withConfiguration: imageConfig)?.withTintColor(#colorLiteral(red: 0.6176958476, green: 0.05836011096, blue: 0.1382402272, alpha: 1), renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(removeFriend), for: .touchUpInside)
        return button
    }()
    
    let addFriendButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 30)
        let image = UIImage(systemName: "person.fill.badge.plus", withConfiguration: imageConfig)?.withTintColor(MAIN_COLOR, renderingMode: .alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        selectionStyle = UITableViewCell.SelectionStyle.none
                
        contentView.addSubview(usernameLabel)
        contentView.addSubview(watchlistCount)
        contentView.addSubview(excludeCount)
        
        usernameLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 5, paddingLeft: 20)
        watchlistCount.anchor(top: usernameLabel.bottomAnchor, left: leftAnchor, paddingLeft: 25)
        excludeCount.anchor(top: usernameLabel.bottomAnchor, left: watchlistCount.rightAnchor, paddingLeft: 15)
    
    }
    
    func removeFriendButtonToView() {
        contentView.addSubview(removeFriendButton)
        removeFriendButton.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: 20)
    }
    
    func addFriendButtonToView() {
        contentView.addSubview(addFriendButton)
        addFriendButton.anchor(top: topAnchor, bottom: bottomAnchor, right: rightAnchor, paddingRight: 20)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func removeFriend() {
        print("REMOVE FRIEND")
    }
    
    @objc func addFriend() {
        print("ADD FRIEND")
    }
    
}
