//
//  CardView.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-12.
//

import UIKit


enum SwipeDirection: Int {
    case left = -1
    case right = 1
}

class CardView: UIView {
    
    //MARK: - Properties
    
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Jag vill vara din margaretea"
        return label
    } ()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .purple
        
        addSubview(imageView)
        
        imageView.fillSuperview()
        
        configureGestureRecognizers()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Actions
    
    @objc func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
        case .began:
            superview?.subviews.forEach({ $0.layer.removeAllAnimations() })
        case .changed:
            pancard(sender: sender)
        case .ended:
            resetCardPosition(sender: sender)
        default: break
        }
    }
    
    @objc func handleGoToMovieInfo() {
        
    }
    
    //MARK: - Helpers
    
    func pancard(sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: nil)
        
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 100
        let rotationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransform.translatedBy(x: translation.x, y: translation.y)
    }
        
    func resetCardPosition(sender: UIPanGestureRecognizer) {
        let direction: SwipeDirection = sender.translation(in: nil).x > 100 ? .right : .left
        let shouldDismissCard = abs(sender.translation(in: nil).x) > 100
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            
            if shouldDismissCard {
                let xtranslation = CGFloat(direction.rawValue) * 1000
                let offScreenTransform = self.transform.translatedBy(x: xtranslation, y: 0)
                self.transform = offScreenTransform
            } else {
                self.transform = .identity
            }
        }) { _ in
            if shouldDismissCard {
                let didLike = direction == .right
                print(didLike) //self.delegate?.cardView(self, didLikeUser:  didLike)
            }
        }
    }
    
    func configureGestureRecognizers() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleGoToMovieInfo))
        addGestureRecognizer(tap)
    }
    
}
