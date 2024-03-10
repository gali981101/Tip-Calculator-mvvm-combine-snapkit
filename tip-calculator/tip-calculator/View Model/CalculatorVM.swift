//
//  CalculatorVM.swift
//  tip-calculator
//
//  Created by Terry Jason on 2024/3/7.
//

import Foundation
import Combine

class CalculatorVM {
    
    // MARK: - Input & Output
    
    struct Input {
        let billPublisher: AnyPublisher<Double, Never>
        let tipPublisher: AnyPublisher<Tip, Never>
        let splitPublisher: AnyPublisher<Int, Never>
        let logoViewTapPublisher: AnyPublisher<Void, Never>
    }
    
    struct Output {
        let updateViewPublisher: AnyPublisher<Result, Never>
        let resetCalculatorPublisher: AnyPublisher<Void, Never>
    }
    
    // MARK: - Combine
    
    private var cancellables = Set<AnyCancellable>()
    private let audioPlayerService: AudioPlayerService
    
    // MARK: - init
    
    init(audioPlayerService: AudioPlayerService = DefaultAudioPlayer()) {
        self.audioPlayerService = audioPlayerService
    }
    
    // MARK: - Methods
    
    func transform(input: Input) -> Output {
        
        let updateViewPublisher = Publishers.CombineLatest3(
            input.billPublisher,
            input.tipPublisher,
            input.splitPublisher)
            .flatMap { [unowned self] (bill, tip, split) in
                let totalTip = getTipAmount(bill: bill, tip: tip)
                let totalBill = bill + totalTip
                let amountPerPerson = totalBill / Double(split)
                
                let result = Result(
                    amountPerPerson: amountPerPerson,
                    totalBill: totalBill,
                    totalTip: totalTip)
                
                return Just(result)
            }.eraseToAnyPublisher()
        
        let resetCalculatorPublisher = input
            .logoViewTapPublisher
            .handleEvents(receiveOutput:  { [unowned self] _ in
                audioPlayerService.playSound()
            })
            .flatMap { return Just($0) }
            .eraseToAnyPublisher()
        
        return Output(
            updateViewPublisher: updateViewPublisher,
            resetCalculatorPublisher: resetCalculatorPublisher)
        
    }
    
}

// MARK: - Calculate Methods

extension CalculatorVM {
    
    private func getTipAmount(bill: Double, tip: Tip) -> Double {
        switch tip {
        case .none:
            return 0
        case .tenPercent:
            return bill * 0.1
        case .fifteenPercent:
            return bill * 0.15
        case .twentyPercent:
            return bill * 0.2
        case .custom(let value):
            return Double(value)
        }
    }
    
}
