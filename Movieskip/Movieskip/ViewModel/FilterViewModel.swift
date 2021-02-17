//
//  FilterViewModel.swift
//  Movieskip
//
//  Created by marchelmon on 2021-02-16.
//

import Foundation

struct FilterViewModel {
    var filter: Filter
    
    var minYearSliderValue: Float {
        return Float(filter.minYear) ?? Float(2000)
    }
    
    var maxYearSliderValue: Float {
        return Float(filter.maxYear) ?? Float(2021)
    }
    
    var popular: Bool {
        return filter.popular
    }
    
    func minYearText(forValue value: Float) -> String {
        return "Min year: \(Int(value))"
    }
    
    func maxYearText(forValue value: Float) -> String {
        return "Max year: \(Int(value))"
    }
    
    
    
    init(filter: Filter) {
        self.filter = filter
    }
    
}
