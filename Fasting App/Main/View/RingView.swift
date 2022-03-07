//
//  RingView.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/01/2022.
//

import Foundation
import UIKit

struct RingViewModel {
    
    let isAnimated: Bool
    let trackColor: UIColor
    let animatedColor: UIColor
    let lblTimer: String?
    let lblFast: String?
    var timeSelected: Int?
    let prsentPicker: (() -> Void)?
    var stopStartBtn: ((_ state: State) -> Void)?
    let state: State
//    let btnStartStop: State
    
    init(
        isAnimated: Bool = false,
        trackColor: UIColor? = nil,
        animatedColor: UIColor? = nil,
        lblTimer: String? = nil,
        lblFast: String? = nil,
        timeSelected: Int? = nil,
        prsentPicker: (() -> Void)? = nil,
        stopStartBtn: ((_ state: State) -> Void)? = nil,
        state: State
//        btnStartStop: State
        ) {
        self.isAnimated = isAnimated
        self.trackColor = trackColor!
        self.animatedColor = animatedColor!
        self.lblTimer = lblTimer
        self.lblFast = lblFast
        self.timeSelected = timeSelected
        self.prsentPicker = prsentPicker
        self.stopStartBtn = stopStartBtn
        self.state = state
//        self.btnStartStop = btnStartStop
    }
    
}

class RingView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var model: RingViewModel {
        didSet {
            lblFast.text = model.lblFast
            lblTimer.text = model.lblTimer
            timeSelected = model.timeSelected ?? 0
            state = model.state
//            btnStartStop.currentState = model.btnStartStop
        }
    }
    
    var state: State? {
        didSet {
            print("DEBUG: State in Ring View \(state)")
            if state == .running {
                animateRing(timeSelected: timeSelected)
            }
        }
    }
    
    var timeSelected: Int = 0
    
    var fastTimer: Int {
        //        return FastStoreModel.shared.currentTimer.count
        5
    }
    
    var trackLayer: CAShapeLayer?
    var timeRing: CAShapeLayer?
    var timer: Timer?
    
    var fastSelected: Int? {
        didSet {
            print("Label is setting up")
        }
    }
    
    let ringView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.layer.borderWidth = 20
        view.addShadow(color: UIColor.black.withAlphaComponent(0.8))
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let centerView: UIView = {
        let view = UIView()
        view.backgroundColor = .ringColor
        view.addShadow()
        return view
    }()
    
    let lblContainerStackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 1
        return view
    }()
    
    var lblTimer: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 27)
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.2
        label.textAlignment = .center
        label.textColor = UIColor.stdText
        return label
    }()
    
    var lblFast: UILabel = {
        var label = UILabel()
        label.font =  UIFont(name: "Montserrat-ExtraLight", size: 18)
        label.textAlignment = .center
        label.textColor = UIColor.stdText
        return label
    }()
    
    lazy var btnStartStop: StartStopButtonView = {
        let view = StartStopButtonView()
        view.callback = { [weak self] in
                self?.handleRingButton()
            }
        return view
    }()
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    init(model: RingViewModel) {
        self.model = model
        super.init(frame: .zero)
        
        backgroundColor = UIColor.black.withAlphaComponent(0.1)
        ringView.layer.borderColor = UIColor.ringColor!.cgColor
        
        addSubview(centerView)
        centerView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(-32)
        }
        
        centerView.addSubview(lblContainerStackView)
        lblContainerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        lblContainerStackView.addArrangedSubview(lblTimer)
        lblContainerStackView.addArrangedSubview(lblFast)
        
        addSubview(ringView)
        ringView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        centerView.addSubview(btnStartStop)
        btnStartStop.snp.makeConstraints {
            $0.centerX.equalTo(lblFast)
            $0.size.equalTo(30)
            $0.top.equalTo(lblContainerStackView.snp.bottom).offset(25)
        }
        btnStartStop.currentState = .stopped
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // =============================================
    // MARK: Lifecycle
    // =============================================
    
    override func layoutSubviews() {
        setupTimeRunningRing()
        super.layoutSubviews()
        layer.cornerRadius = frame.width/2
        ringView.layer.cornerRadius = ringView.frame.width/2
        centerView.layer.cornerRadius = centerView.frame.width/2
        setupLabelTap()
        
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    @objc func labelTapped() {
        model.prsentPicker?()
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblTimer.isUserInteractionEnabled = true
        lblTimer.addGestureRecognizer(labelTap)
    }
    
    func animateRing(timeSelected: Int) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(timeSelected)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        timeRing?.add(basicAnimation, forKey: "strokeEnd")
    }
    
    func setupTimeRunningRing() {
        let radius = frame.size.width/2
        trackLayer = CAShapeLayer.create(
            strokeColor: UIColor.ringBackground ?? .gray,
            fillColor: UIColor.clear,
            radius: radius
        )
        addShadow()
        
        layer.addSublayer(trackLayer!)
        
        timeRing = CAShapeLayer.create(
            strokeColor: model.animatedColor,
            fillColor: UIColor.clear,
            radius: radius
        )
        layer.addSublayer(timeRing!)
        timeRing?.strokeEnd = 0
    }
    
    func handleRingButton() {
        model.stopStartBtn?(btnStartStop.currentState)
    }
}
