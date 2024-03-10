//
//  TipInputView.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/6.
//

import UIKit
import Combine
import CombineCocoa

class TipInputView: UIView {
    
    // MARK: - Combine
    
    private let tipSubject: CurrentValueSubject<Tip, Never> = .init(.none)
    
    private var cancellable = Set<AnyCancellable>()
    
    var valuePublisher: AnyPublisher<Tip, Never> {
        return tipSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UIElement
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        
        view.configure(
            topText: "Choose",
            bottomText: "your tip"
        )
        
        return view
    }()
    
    private lazy var tenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .tenPercent)
        
        button.accessibilityIdentifier = ScreenIdentifier
            .TipInputView
            .tenPercentButton
            .rawValue
        
        button.tapPublisher.flatMap {
            Just(Tip.tenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellable)
        
        return button
    }()
    
    private lazy var fifteenPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .fifteenPercent)
        
        button.accessibilityIdentifier = ScreenIdentifier
            .TipInputView
            .fifteenPercentButton
            .rawValue
        
        button.tapPublisher.flatMap {
            Just(Tip.fifteenPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellable)
        
        return button
    }()
    
    private lazy var twentyPercentTipButton: UIButton = {
        let button = buildTipButton(tip: .twentyPercent)
        
        button.accessibilityIdentifier = ScreenIdentifier
            .TipInputView
            .twentyPercentButton
            .rawValue
        
        button.tapPublisher.flatMap {
            Just(Tip.twentyPercent)
        }.assign(to: \.value, on: tipSubject)
            .store(in: &cancellable)
        
        return button
    }()
    
    private lazy var customTipButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Custom tip", for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        
        button.backgroundColor = ThemeColor.primary
        button.tintColor = .white
        
        button.addCornerRadius(radius: 8.0)
        
        button.accessibilityIdentifier = ScreenIdentifier
            .TipInputView
            .customTipButton
            .rawValue
        
        button.tapPublisher.sink { [weak self] _ in
            self?.handleCustomTipButton()
        }.store(in: &cancellable)
        
        return button
    }()
    
    private lazy var buttonHStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            tenPercentTipButton,
            fifteenPercentTipButton,
            twentyPercentTipButton
        ])
        
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.spacing = 16
        
        return stackView
    }()
    
    private lazy var buttonVStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            buttonHStackView,
            customTipButton
        ])
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        
        return stackView
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        layOut()
        observe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - LayOut

extension TipInputView {
    
    private func layOut() {
        [headerView, buttonVStackView].forEach(addSubview(_:))
        
        buttonVStackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalTo(buttonVStackView.snp.leading).offset(-24)
            make.width.equalTo(68)
            make.centerY.equalTo(buttonHStackView.snp.centerY)
        }
    }
    
}

// MARK: - Methods

extension TipInputView {
    
    private func resetView() {
        [tenPercentTipButton,
         fifteenPercentTipButton,
         twentyPercentTipButton,
         customTipButton].forEach {
            $0.backgroundColor = ThemeColor.primary
        }
        
        let text = NSMutableAttributedString(
            string: "Custom tip",
            attributes: [.font: ThemeFont.bold(ofSize: 20)]
        )
        
        customTipButton.setAttributedTitle(text, for: .normal)
    }
    
    func reset() {
        tipSubject.send(.none)
    }
    
}

// MARK: - Combine Methods

extension TipInputView {
    
    private func observe() {
        tipSubject.sink { [unowned self] tip in
            self.resetView()
            
            switch tip {
            case .none:
                break
            case .tenPercent:
                tenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .fifteenPercent:
                fifteenPercentTipButton.backgroundColor = ThemeColor.secondary
            case .twentyPercent:
                twentyPercentTipButton.backgroundColor = ThemeColor.secondary
            case .custom(value: let value):
                customTipButton.backgroundColor = ThemeColor.secondary
                
                let text = NSMutableAttributedString(
                    string: "$\(value)",
                    attributes: [.font: ThemeFont.bold(ofSize: 20)])
                
                text.addAttributes([
                    .font: ThemeFont.bold(ofSize: 14)
                ], range: NSMakeRange(0, 1))
                
                customTipButton.setAttributedTitle(text, for: .normal)
            }
        }.store(in: &cancellable)
    }
    
}

// MARK: - Factory

extension TipInputView {
    
    private func handleCustomTipButton() {
        
        let alertController: UIAlertController = {
            
            let controller = UIAlertController(
                title: "Enter custom tip",
                message: nil,
                preferredStyle: .alert)
            
            controller.addTextField {
                $0.placeholder = "請填寫"
                $0.keyboardType = .numberPad
                $0.autocorrectionType = .no
            }
            
            let cancelAction = UIAlertAction(
                title: "Cancel",
                style: .cancel)
            
            let okAction = UIAlertAction(
                title: "OK",
                style: .default) { [weak self] _ in
                    guard let text = controller.textFields?.first?.text,
                          let value = Int(text) else { return }
                    
                    self?.tipSubject.send(.custom(value: value))
                }
            
            [okAction, cancelAction].forEach(controller.addAction(_:))
            
            return controller
        }()
        
        parentViewController?.present(alertController, animated: true)
    }
    
    private func buildTipButton(tip: Tip) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.backgroundColor = ThemeColor.primary
        button.addCornerRadius(radius: 8.0)
        
        let text = NSMutableAttributedString(
            string: tip.stringValue,
            attributes: [
                .font: ThemeFont.bold(ofSize: 20),
                .foregroundColor: UIColor.white
            ]
        )
        
        text.addAttributes([
            .font: ThemeFont.oldStyleBold(ofSize: 14)
        ], range: NSMakeRange(2, 1))
        
        button.setAttributedTitle(text, for: .normal)
        
        return button
    }
    
}





















