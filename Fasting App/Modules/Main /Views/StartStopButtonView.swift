//
//  StartStopButtonView.swift
//  Fasting App
//
//  Created by indre zibolyte on 23/02/2022.
//

import Foundation
import UIKit

enum State {
    case stopped, running
}

// struct StartStopModel {
//    let state: State
//
//    init( state: State = .running) {
//        self.state = state
//    }
// }

class StartStopButtonView: TouchableView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    lazy var btnStart: UIImageView = {
        var view = UIImageView()
        view.tintColor = .stdText
        view.image = UIImage(systemName: "play.fill")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        return view
    }()
    
    lazy var btnStop: UIImageView = {
        var view = UIImageView()
        view.tintColor = .stdText
        view.image = UIImage(systemName: "stop.fill")?.withRenderingMode(.alwaysTemplate)
        view.clipsToBounds = true
        return view
    }()
    
    var currentState: State = .stopped {
        didSet {
            switch currentState {
            case .running:
                btnStart.isHidden = true
                btnStop.isHidden = false
            case .stopped:
                btnStart.isHidden = false
                btnStop.isHidden = true
            }
        }
    }
    
//    var model: StartStopModel {
//        didSet { currentState = model.state }
//    }
    
    // =============================================
    // MARK: Initialization
    // =============================================
    
    init() {
        super.init(frame: .zero)
        
        addSubview(btnStart)
        btnStart.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(35)
        }
        
        addSubview(btnStop)
        btnStop.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(35)
        }
        
        btnStop.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
