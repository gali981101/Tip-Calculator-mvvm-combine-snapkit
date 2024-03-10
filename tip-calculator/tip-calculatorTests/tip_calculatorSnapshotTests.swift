//
//  tip_calculatorSnapshotTests.swift
//  tip-calculatorTests
//
//  Created by Terry Jason on 2024/3/9.
//

import XCTest
import SnapshotTesting

@testable import tip_calculator

final class tip_calculatorSnapshotTests: XCTestCase {
    
    private var screenWidth: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    
    func testLogoView() {
        let size = CGSize(width: screenWidth, height: 48)
        let view = LogoView()
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialResultView() {
        let size = CGSize(width: screenWidth, height: 224)
        let view = ResultView()
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testResultViewWithValues() {
        let size = CGSize(width: screenWidth, height: 224)
        let result = Result(
            amountPerPerson: 89.17,
            totalBill: 89,
            totalTip: 64)
        
        let view = ResultView()
        view.configure(result: result)
        
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testBillInputView() {
        let size = CGSize(width: screenWidth, height: 56)
        let view = BillInputView()
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testBillInputViewWithValues() {
        let size = CGSize(width: screenWidth, height: 56)
        
        let view = BillInputView()
        
        let textField = view.allSubViewsOf(type: UITextField.self)
            .first
        textField?.text = "500"
        
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialTipInputView() {
        let size = CGSize(width: screenWidth, height: 56+56+16)
        let view = TipInputView()
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testTipInputViewWithValues() {
        let size = CGSize(width: screenWidth, height: 56+56+16)
        let view = TipInputView()
        
        let button = view.allSubViewsOf(type: UIButton.self)
            .first
        button?.sendActions(for: .touchUpInside)
        
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testInitialSplitInputView() {
        let size = CGSize(width: screenWidth, height: 56)
        let view = SplitInputView()
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
    func testSplitInputViewWithSelection() {
        let size = CGSize(width: screenWidth, height: 56)
        let view = SplitInputView()
        
        let button = view.allSubViewsOf(type: UIButton.self)
            .last
        button?.sendActions(for: .touchUpInside)
        
        assertSnapshot(matching: view, as: .image(size: size))
    }
    
}

extension UIView {
    
    /** This is the function to get subViews of a view of a particular type
     */
    func subViews<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        for view in self.subviews {
            if let aView = view as? T{
                all.append(aView)
            }
        }
        return all
    }
    
    
    /** This is a function to get subViews of a particular type from view recursively. It would look recursively in all subviews and return back the subviews of the type T */
    func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}
