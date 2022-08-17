//
//  RingView.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/01/2022.
//

import Foundation
import SnapKit
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
            stroke = model.stroke ?? 0
            timeSelected = Int(model.timeSelected ?? 0)
            state = model.state
            timeLapsed = model.timeLapsed
           
        }
    }
    
    var state: State? {
        didSet {
            btnStartStop.currentState = state ?? .stopped
            if
                let stroke = stroke,
                state == .running {
                animateRing(stroke: stroke)
            }
            if state == .stopped {
                centerView.layer.removeAllAnimations()
            }
        }
    }

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
    
    var initialSetupDone: Bool = false {
        didSet {
            setupView()
        }
    }
    
    // ========================================
    // MARK: Initialization
    // ========================================
    
    init(model: RingViewModel) {
        self.model = model
        super.init(frame: .zero)
        
        addSubview(centerView)
        centerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        centerView.addSubview(lblContainerStackView)
        lblContainerStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        lblContainerStackView.addArrangedSubview(lblTimer)
        lblTimer.snp.makeConstraints {
            $0.height.equalTo(60)
        }

        lblContainerStackView.addArrangedSubview(lblFast)

        centerView.addSubview(btnStartStop)
        btnStartStop.snp.makeConstraints {
            $0.centerX.equalTo(lblFast)
            $0.size.equalTo(35)
            $0.top.equalTo(lblContainerStackView.snp.bottom).offset(15)
        }
 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        centerView.layer.cornerRadius = centerView.frame.width/2
        
        if !initialSetupDone {
            setupView()
            initialSetupDone = true
        }
    }
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func setupView() {
        setupTimeRunningRing()
        setupLabelTap()
    }
    
    @objc func labelTapped() {
        model.prsentPicker?()
    }
    
    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(labelTapped))
        lblTimer.isUserInteractionEnabled = true
        lblTimer.addGestureRecognizer(labelTap)
    }
    
        func animateRing(stroke: CGFloat) {

        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = true
        timeRing?.removeAllAnimations()
        timeRing?.add(basicAnimation, forKey: "strokeEnd")
        timeRing?.strokeEnd = model.stroke ?? 0
    }
        
    func setupTimeRunningRing() {
        
        let radius = (centerView.frame.size.width/2) - 30
        let center = CGPoint(x: centerView.frame.size.width/2, y: centerView.frame.size.width/2)
        
        trackLayer = CAShapeLayer.create(
            arcCenter: center,
            strokeColor: UIColor.ringTrackColor ?? .gray,
            fillColor: UIColor.clear,
            radius: radius
        )
        
        if let tracklayer = trackLayer {
            centerView.layer.addSublayer(tracklayer)
        }
       
        timeRing = CAShapeLayer.create(
            arcCenter: center,
            strokeColor: model.animatedColor ?? .lightGray,
            fillColor: UIColor.clear,
            radius: radius
        )
        if let timeRing = timeRing {
            centerView.layer.addSublayer(timeRing)
        }

        timeRing?.strokeEnd = stroke ?? 0
        
    }
    
    func handleRingButton() {
        model.stopStartBtn?(btnStartStop.currentState)
    }
}
