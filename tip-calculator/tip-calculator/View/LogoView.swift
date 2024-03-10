//
//  LogoView.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/6.
//

import UIKit

class LogoView: UIView {
    
    // MARK: - UIElement
    
    private let imageView: UIImageView = {
        let view = UIImageView(image: .init(named: "icCalculatorBW"))
        view.contentMode = .scaleAspectFit
        
        return view
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        
        let text = NSMutableAttributedString(
            string: "Gali TIP",
            attributes: [.font: ThemeFont.oldStyleBold(ofSize: 16)])
        
        text.addAttributes([.font: ThemeFont.bold(ofSize: 24)], range: NSMakeRange(4, 4))

        label.attributedText = text
        
        return label
    }()
    
    private let bottomLabel: UILabel = {
        LabelFactory.build(text: "Calculator", font: ThemeFont.bookItalic(ofSize: 20), textAlignment: .left)
    }()
    
    private lazy var vStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            topLabel,
            bottomLabel
        ])
        
        view.axis = .vertical
        view.spacing = -4
        
        return view
    }()
    
    private lazy var hStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [
            imageView,
            vStackView
        ])
        
        view.axis = .horizontal
        view.alignment = .center
        view.spacing = 8
        
        return view
    }()
    
    // MARK: - init
    
    init() {
        super.init(frame: .zero)
        accessibilityIdentifier = ScreenIdentifier
            .LogoView
            .logoView
            .rawValue
        
        layOut()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - LayOut

extension LogoView {
    
    private func layOut() {
        addSubview(hStackView)
        
        hStackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.height.equalTo(imageView.snp.width)
        }
    }
    
}





