//
//  BillInputView.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/6.
//

import UIKit
import Combine
import CombineCocoa

class BillInputView: UIView {
    
    // MARK: - Combine
    
    private let billSubject: PassthroughSubject<Double, Never> = .init()
    private var cancellables = Set<AnyCancellable>()
    
    var valuePublisher: AnyPublisher<Double, Never> {
        return billSubject.eraseToAnyPublisher()
    }
    
    // MARK: - UIElement
    
    private let headerView: HeaderView = {
        let view = HeaderView()
        
        view.configure(
            topText: "Enter",
            bottomText: "your bill"
        )
        
        return view
    }()
    
    private let textFieldContainerView: UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.addCornerRadius(radius: 8.0)
        
        return view
    }()
    
    private let currencyDollarSignLabel: UILabel = {
        let label = LabelFactory.build(
            text: "$",
            font: ThemeFont.bold(ofSize: 24))
        
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        
        textField.borderStyle = .none
        textField.keyboardType = .decimalPad
        
        textField.font = ThemeFont.bold(ofSize: 28)
        
        textField.tintColor = ThemeColor.text
        textField.textColor = ThemeColor.text
        
        textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        textField.accessibilityIdentifier = ScreenIdentifier
            .BillInputView
            .textField
            .rawValue
        
        // Toolbar
        let toolbar = UIToolbar(
            frame: CGRect(x: 0, y: 0, width: frame.size.width, height: 36)
        )
        
        toolbar.barStyle = .default
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneButtonTapped)
        )
        
        let spacer = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: self,
            action: nil
        )
        
        toolbar.items = [spacer, doneButton]
        toolbar.isUserInteractionEnabled = true
        
        textField.inputAccessoryView = toolbar
        
        return textField
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

extension BillInputView {
    
    private func layOut() {
        [headerView, textFieldContainerView].forEach(addSubview(_:))
        
        headerView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalTo(textFieldContainerView.snp.centerY)
            make.width.equalTo(68)
            make.height.equalTo(24)
            make.trailing.equalTo(textFieldContainerView.snp.leading).offset(-24)
        }
        
        textFieldContainerView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
        }
        
        textFieldContainerView.addSubview(currencyDollarSignLabel)
        textFieldContainerView.addSubview(textField)
        
        currencyDollarSignLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(textFieldContainerView.snp.leading).offset(16)
        }
        
        textField.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.equalTo(currencyDollarSignLabel.snp.trailing).offset(16)
            make.trailing.equalTo(textFieldContainerView.snp.trailing).offset(-16)
        }
    }
    
}

// MARK: - @objc Func

extension BillInputView {
    
    @objc private func doneButtonTapped() {
        textField.endEditing(true)
    }
    
}

// MARK: - Methods

extension BillInputView {
    
    func reset() {
        textField.text = nil
        billSubject.send(0)
    }
    
}

// MARK: - Combine Methods

extension BillInputView {
    
    private func observe() {
        textField.textPublisher.sink { [unowned self] text in
            billSubject.send(text?.doubleValue ?? 0.0)
        }.store(in: &cancellables)
    }
    
}
