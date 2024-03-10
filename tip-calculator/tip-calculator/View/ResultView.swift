//
//  ResultView.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/6.
//

import UIKit

class ResultView: UIView {
    
    // MARK: - UIElement
    
    private let headerLabel: UILabel = {
        LabelFactory.build(
            text: "Total p/person",
            font: ThemeFont.oldStyleBold(ofSize: 18))
    }()
    
    private let amountPerPersonLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        
        let text = NSMutableAttributedString(
            string: "$0",
            attributes: [
                .font: ThemeFont.bold(ofSize: 48)
            ]
        )
        
        text.addAttributes([
            .font: ThemeFont.bold(ofSize: 24)
        ], range: NSMakeRange(0, 1))
        
        label.attributedText = text
        label.accessibilityIdentifier = ScreenIdentifier
            .ResultView
            .totalAmountPerPersonValueLabel
            .rawValue
        
        return label
    }()
    
    private let horizontalLineView: UIView = {
        let view = UIView()
        view.backgroundColor = ThemeColor.separator
        
        return view
    }()
    
    private let totalBillView: AmountView = {
        let view = AmountView(
            title: "Total bill",
            textAlignment: .left,
            amountLabelIdentifier: ScreenIdentifier
                .ResultView
                .totalBillValueLabel
                .rawValue
        )
        
        return view
    }()
    
    private let totalTipView: AmountView = {
        let view = AmountView(
            title: "Total tip",
            textAlignment: .right,
            amountLabelIdentifier: ScreenIdentifier
                .ResultView
                .totalTipValueLabel
                .rawValue
        )
        
        return view
    }()
    
    private lazy var vStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            headerLabel,
            amountPerPersonLabel,
            horizontalLineView,
            buildSpacerView(height: 0),
            hStackView
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }()
    
    private lazy var hStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            totalBillView,
            UIView(),
            totalTipView
        ])
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        layOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - LayOut

extension ResultView {
    
    private func layOut() {
        backgroundColor = .white
        
        addSubview(vStackView)
        
        vStackView.snp.makeConstraints { make in
            make.top.equalTo(snp.top).offset(24)
            make.leading.equalTo(snp.leading).offset(24)
            make.trailing.equalTo(snp.trailing).offset(-24)
            make.bottom.equalTo(snp.bottom).offset(-24)
        }
        
        horizontalLineView.snp.makeConstraints { make in
            make.height.equalTo(2)
        }
        
        addShadow(
            offset: CGSize(width: 0, height: 3),
            color: .black,
            radius: 12.0,
            opacity: 0.1)
    }
    
}

// MARK: - Set

extension ResultView {
    
    func configure(result: Result) {
        let text = NSMutableAttributedString(
            string: String(result.amountPerPerson),
            attributes: [.font: ThemeFont.bold(ofSize: 48)])
        
        amountPerPersonLabel.attributedText = text
        
        totalBillView.configure(amount: result.totalBill)
        totalTipView.configure(amount: result.totalTip)
    }
    
}

// MARK: - Reuse Func

extension ResultView {
    
    private func buildSpacerView(height: CGFloat) -> UIView {
        let view = UIView()
        view.heightAnchor.constraint(equalToConstant: height).isActive = true
        return view
    }
    
}














