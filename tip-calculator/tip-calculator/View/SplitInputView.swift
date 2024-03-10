//
//  SplitInputView.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/6.
//

import UIKit
import Combine
import CombineCocoa

class SplitInputView: UIView {
    
    // MARK: - Combine
    
    private let splitSubject: CurrentValueSubject<Int, Never> = .init(1)
    
    private var cancellables = Set<AnyCancellable>()
    
    var valuePublisher: AnyPublisher<Int, Never> {
        return splitSubject.removeDuplicates().eraseToAnyPublisher()
    }
    
    // MARK: - UIElement
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        view.configure(topText: "Split", bottomText: "the total")
        return view
    }()
    
    private lazy var decrementButton: UIButton = {
        let button = buildButton(
            text: "-",
            corner: [.layerMinXMaxYCorner, .layerMinXMinYCorner])
        
        button.accessibilityIdentifier = ScreenIdentifier
            .SplitInputView
            .decrementButton
            .rawValue
        
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value == 1 ? 1 : splitSubject.value - 1)
        }
        .assign(to: \.value, on: splitSubject)
        .store(in: &cancellables)
        
        return button
    }()
    
    private lazy var incrementButton: UIButton = {
        let button = buildButton(
            text: "+",
            corner: [.layerMaxXMinYCorner, .layerMaxXMaxYCorner])
        
        button.accessibilityIdentifier = ScreenIdentifier
            .SplitInputView
            .incrementButton
            .rawValue
        
        button.tapPublisher.flatMap { [unowned self] _ in
            Just(splitSubject.value + 1)
        }
        .assign(to: \.value, on: splitSubject)
        .store(in: &cancellables)
        
        return button
    }()
    
    private lazy var quantityLabel: UILabel = {
        let label = LabelFactory.build(
            text: "1",
            font: ThemeFont.bold(ofSize: 20),
            backgroundColor: .white
        )
        
        label.accessibilityIdentifier = ScreenIdentifier
            .SplitInputView
            .quantityValueLabel
            .rawValue
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            decrementButton,
            quantityLabel,
            incrementButton
        ])
        
        stackView.axis = .horizontal
        stackView.spacing = 0
        
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

extension SplitInputView {
    
    private func layOut() {
        [headerView, stackView].forEach(addSubview(_:))
        
        stackView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
        }
        
        [incrementButton, decrementButton].forEach { button in
            button.snp.makeConstraints { make in
                make.width.equalTo(button.snp.height)
            }
        }
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(stackView.snp.centerY)
            make.trailing.equalTo(stackView.snp.leading).offset(-24)
            make.width.equalTo(68)
        }
    }
    
}

// MARK: - Methods

extension SplitInputView {
    
    private func observe() {
        splitSubject.sink { [unowned self] quantity in
            quantityLabel.text = quantity.stringValue
        }
        .store(in: &cancellables)
    }
    
    func reset() {
        splitSubject.send(1)
    }
    
}

// MARK: - Factory

extension SplitInputView {
    
    private func buildButton(text: String, corner: CACornerMask) -> UIButton {
        let button = UIButton()
        
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = ThemeFont.bold(ofSize: 20)
        button.backgroundColor = ThemeColor.primary
        
        button.addRoundedCorners(corners: corner, radius: 8.0)
        
        return button
    }
    
}
