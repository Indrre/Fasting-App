//
//  RingView.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/01/2022.
//

import Foundation
import UIKit

struct RingViewModel {
    
    let trackColor: UIColor?
    let animatedColor: UIColor?
    let timer: String?
    let fast: String?
    let timeSelected: TimeInterval?
    let state: State
    let timeLapsed: Float
    let stroke: CGFloat?
    let prsentPicker: (() -> Void)?
    let stopStartBtn: ((_ state: State) -> Void)?
    
    init(
        trackColor: UIColor? = nil,
        animatedColor: UIColor? = nil,
        timer: String? = nil,
        fast: String? = nil,
        timeSelected: TimeInterval?,
        state: State,
        timeLapsed: Float,
        stroke: CGFloat,
        prsentPicker: (() -> Void)? = nil,
        stopStartBtn: ((_ state: State) -> Void)? = nil
        
        ) {
        self.trackColor = trackColor
        self.animatedColor = animatedColor
        self.timer = timer
        self.fast = fast
        self.timeSelected = timeSelected
        self.state = state
        self.timeLapsed = timeLapsed
        self.stroke = stroke
        self.prsentPicker = prsentPicker
        self.stopStartBtn = stopStartBtn
    }
}

class RingView: UIView {
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    var trackLayer: CAShapeLayer?
    var timeRing: CAShapeLayer?
    var timer: Timer?
    var timeLapsed: Float?
    var stroke: CGFloat?
    var timeSelected: Int = 0
    let sender = "FastSelection"
    
    var model: RingViewModel {
        didSet {
            lblFast.text = model.fast
            lblTimer.text = model.timer
            timeSelected = Int(model.timeSelected ?? 0)
            state = model.state
            timeLapsed = model.timeLapsed
            stroke = model.stroke ?? 0
        }
    }
    var state: State? {
        didSet {
            btnStartStop.currentState = state!
            if state == .running {
                animateRing(timeSelected: timeSelected, stroke: stroke ?? 0)
            }
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
    
    func animateRing(timeSelected: Int, stroke: CGFloat) {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.toValue = 1
        basicAnimation.duration = CFTimeInterval(timeSelected)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        timeRing?.add(basicAnimation, forKey: "strokeEnd")
        timeRing?.strokeEnd = stroke
    }
    
    func setupTimeRunningRing() {
        let radius = frame.size.width/2
        trackLayer = CAShapeLayer.create(
            strokeColor: UIColor.ringBackground ?? .gray,
            fillColor: UIColor.clear,
            radius: radius
        )
        
        layer.addSublayer(trackLayer!)
        
        timeRing = CAShapeLayer.create(
            strokeColor: model.animatedColor ?? .lightGray,
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
