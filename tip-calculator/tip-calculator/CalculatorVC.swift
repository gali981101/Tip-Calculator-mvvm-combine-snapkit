//
//  ViewController.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/6.
//

import UIKit
import SnapKit
import Combine
import CombineCocoa

class CalculatorVC: UIViewController {
    
    private let vm = CalculatorVM()
    private var cancellables = Set<AnyCancellable>()
    
    private lazy var viewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        view.addGestureRecognizer(tapGesture)
        
        return tapGesture.tapPublisher.flatMap { _ in Just(()) }
            .eraseToAnyPublisher()
    }()
    
    private lazy var logoViewTapPublisher: AnyPublisher<Void, Never> = {
        let tapGesture = UITapGestureRecognizer(target: self, action: nil)
        tapGesture.numberOfTapsRequired = 2
        
        logoView.addGestureRecognizer(tapGesture)
        
        return tapGesture.tapPublisher.flatMap { _ in Just(()) }
            .eraseToAnyPublisher()
    }()
    
    // MARK: - View
    
    private let logoView = LogoView()
    private let resultView = ResultView()
    private let billInputView = BillInputView()
    private let tipInputView = TipInputView()
    private let splitInputView = SplitInputView()
    
    // MARK: - StackView
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            logoView,
            resultView,
            billInputView,
            tipInputView,
            splitInputView,
            UIView()
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 36
        
        return stackView
    }()
    
}

// MARK: - LifeCycle

extension CalculatorVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layOut()
        bind()
        observe()
    }
    
}

// MARK: - LayOut

extension CalculatorVC {
    
    private func layOut() {
        view.backgroundColor = ThemeColor.bg
        view.addSubview(vStackView)
        
        vStackView.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leadingMargin).offset(16)
            $0.trailing.equalTo(view.snp.trailingMargin).offset(-16)
            $0.bottom.equalTo(view.snp.bottomMargin).offset(-16)
            $0.top.equalTo(view.snp.topMargin).offset(16)
        }
        
        logoView.snp.makeConstraints {
            $0.height.equalTo(48)
        }
        
        resultView.snp.makeConstraints {
            $0.height.equalTo(224)
        }
        
        billInputView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
        
        tipInputView.snp.makeConstraints {
            $0.height.equalTo(128)
        }
        
        splitInputView.snp.makeConstraints {
            $0.height.equalTo(56)
        }
    }
    
}

// MARK: - Combine Methods

extension CalculatorVC {
    
    private func bind() {
        let input = CalculatorVM.Input(
            billPublisher: billInputView.valuePublisher,
            tipPublisher: tipInputView.valuePublisher,
            splitPublisher: splitInputView.valuePublisher,
            logoViewTapPublisher: logoViewTapPublisher)
        
        let output = vm.transform(input: input)
        
        output.updateViewPublisher.sink { [unowned self] result in
            resultView.configure(result: result)
        }
        .store(in: &cancellables)
        
        output.resetCalculatorPublisher.sink { [unowned self] _ in
            billInputView.reset()
            tipInputView.reset()
            splitInputView.reset()
            
            UIView.animate(
                withDuration: 0.1,
                delay: 0,
                usingSpringWithDamping: 5.0,
                initialSpringVelocity: 0.5,
                options: .curveEaseInOut) {
                    self.logoView.transform = .init(scaleX: 1.5, y: 1.5)
                } completion: { _ in
                    UIView.animate(withDuration: 0.1) {
                        self.logoView.transform = .identity
                    }
                }
        }
        .store(in: &cancellables)
    }
    
    private func observe() {
        viewTapPublisher.sink { [unowned self] _ in
            view.endEditing(true)
        }
        .store(in: &cancellables)
    }
    
}

