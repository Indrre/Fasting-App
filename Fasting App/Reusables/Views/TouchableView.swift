//
//  TouchableView.swift
//  Fasting App
//
//  Created by indre zibolyte on 22/02/2022.
//

import Foundation
import UIKit

class TouchableView: UIView {

    // =============================================
    // MARK: Initialization
    // =============================================

    var callback: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // =============================================
    // MARK: Helpers
    // =============================================

    private func touched() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 2,
            options: [],
            animations: {
                self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        })
    }

    func released() {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 2,
            options: [],
            animations: {
                self.transform = CGAffineTransform(scaleX: 1, y: 1)
        })
    }

    // =============================================
    // MARK: LifeCycle
    // =============================================

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched()
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            if bounds.insetBy(dx: 0, dy: 0).contains(location) {
                callback?()
            }
        }

        released()
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch: UITouch = touches.first {
            let location: CGPoint = touch.location(in: self)
            if bounds.insetBy(dx: 0, dy: 0).contains(location) {
                touched()
            } else {
                released()
            }
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        released()
    }
}

//class TouchableView: UIView {
//
//    // ==========================================
//    // MARK: Properties
//    // ==========================================
//
//    var isFade: Bool = false
//
//    // ==========================================
//    // MARK: Callbacks
//    // ==========================================
//
//    var callback: ((UIView) -> Void)?
//
//    // ==========================================
//    // MARK: Initialization
//    // ==========================================
//
//    init() {
//        super.init(frame: .zero)
//        isUserInteractionEnabled = true
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    // ==========================================
//    // MARK: Helpers
//    // ==========================================
//
//    private func touched() {
//        if isFade {
//            fadeOut(alpha: 0.5)
//            return
//        }
//
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            usingSpringWithDamping: 0.5,
//            initialSpringVelocity: 2,
//            options: [],
//            animations: {
//                self.transform = CGAffineTransform(
//                    scaleX: 0.95,
//                    y: 0.95
//                )
//            }
//        )
//    }
//
//    func released() {
//        if isFade {
//            fadeIn()
//            return
//        }
//
//        UIView.animate(
//            withDuration: 0.3,
//            delay: 0,
//            usingSpringWithDamping: 0.5,
//            initialSpringVelocity: 2,
//            options: [],
//            animations: {
//                self.transform = CGAffineTransform(
//                    scaleX: 1,
//                    y: 1
//                )
//            }
//        )
//    }
//
//}

//// ==========================================
//// MARK: UITouchDelegate
//// ==========================================
//
//extension TouchableView {
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        touched()
//    }
//    
//    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch: UITouch = touches.first {
//            let location: CGPoint = touch.location(in: self)
//            if bounds.insetBy(dx: 0, dy: 0).contains(location) {
//                UIImpactFeedbackGenerator().impactOccurred()
//                callback?(self)
//            }
//        }; released()
//    }
//    
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let touch: UITouch = touches.first {
//            let location: CGPoint = touch.location(in: self)
//            if bounds.insetBy(dx: 0, dy: 0).contains(location) {
//                touched()
//            } else {
//                released()
//            }
//        }
//    }
//    
//    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        released()
//    }
//    
//}
//
