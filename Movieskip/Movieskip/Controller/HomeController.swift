//
//  HomeController.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    private var topCard: CardView?
    
    private let topStack = HomeNavigationStackView()
    private let bottomStack = BottomControlsStackView()

    private let deckView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardView = CardView()
        deckView.addSubview(cardView)
        cardView.fillSuperview()
        topCard = cardView
        
        configureUI()
        
        
    }
    
//MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        
        let stack = UIStackView(arrangedSubviews: [topStack, deckView, bottomStack])
                
        view.addSubview(stack)
        
        stack.axis = .vertical
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor)
        
        //KANSKE BEHÖVER ÄNDRAS, SÅ GJORDE HAN INTE I TUTORIAL: funkar det så funkar det....
        bottomStack.anchor(bottom: view.bottomAnchor, paddingBottom: 30)
        
        stack.isLayoutMarginsRelativeArrangement = true
        stack.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        stack.bringSubviewToFront(deckView)
    }

    
}
