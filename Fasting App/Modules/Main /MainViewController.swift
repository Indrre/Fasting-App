//
//  MainViewController.swift
//  Fasting App
//
//  Created by indre zibolyte on 25/01/2022.
//

import Foundation
import UIKit
import SnapKit

class MainViewController: ViewController {
    
    // =============================================
    // MARK: Components
    // =============================================
    
    lazy var profileHeaderView: ProfileHeaderView = {
        return ProfileHeaderView(model: model.profileHeaderModel)
    }()
    
    lazy var fastRingView: RingView = {
        return RingView(model: model.ringModel)
    }()
    
    lazy var mainTileView: MainTileView = {
        return MainTileView(model: model.mainTileModel)
    }()
    
    let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 20
        return view
    }()
    
    // =============================================
    // MARK: Properties
    // =============================================
    
    lazy var model: MainViewModel = {
        let model = MainViewModel()
        model.refreshController = { [weak self] in
            self?.setup()
        }
        model.pushController = { [weak self] controller in
            self?.navigationController?.pushViewController(
                controller,
                animated: true
            )
        }
        model.presentController = { [weak self] controller in
            self?.present(
                controller,
                animated: false,
                completion: nil
            )
        }
        return model
    }()
    
    // =============================================
    // MARK: Lifecycle
    // =============================================
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.viewDidLoad()

//        setBackground()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        setup()
        
    }
    
    override func loadView() {
        super.loadView()
        
        stackView.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        view.addSubview(profileHeaderView)
        profileHeaderView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(70)
            $0.left.right.equalToSuperview().inset(10)
            $0.height.equalTo(70)
        }
        
        view.addSubview(scrollView)
        scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        scrollView.snp.makeConstraints {
            $0.top.equalTo(profileHeaderView.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        let timerContainer = UIView()
        stackView.addArrangedSubview(timerContainer)
        timerContainer.snp.makeConstraints {
            $0.size.equalTo(view.snp.width)
        }
        
        timerContainer.addSubview(fastRingView)
        fastRingView.snp.makeConstraints {
            $0.size.equalTo(timerContainer.snp.width).multipliedBy(0.7)
            $0.center.equalToSuperview()
        }
                
        stackView.addArrangedSubview(mainTileView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        stackView.layoutIfNeeded()
        scrollView.contentSize = CGSize(
            width: view.frame.size.width,
            height: stackView.frame.size.height
        )
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if #available(iOS 13.0, *) {
            if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
                fastRingView.layer.borderColor = UIColor.stdBackground!.cgColor
                view.addShadow(color: UIColor.black.withAlphaComponent(0.8))
                fastRingView.layer.borderWidth = 20
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setLargeTitleDisplayMode(.never)
    }
    
    deinit {
        debugPrint("Deallocating timeringViewController")
    }
    
    // =============================================
    // MARK: Helpers
    // =============================================
    
    func setup() {
        profileHeaderView.model = model.profileHeaderModel
        fastRingView.model = model.ringModel
        mainTileView.model = model.mainTileModel
        
        view.layoutIfNeeded()
    }
}
