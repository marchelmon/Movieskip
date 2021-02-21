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
        return filter.minYear
    }
    
    var maxYearSliderValue: Float {
        return filter.maxYear
    }
    
    var popular: Bool {
        return filter.popular
    }
    
    func minYearText(forValue value: Float) -> String {
        return "\(Int(value))"
    }
    
    func maxYearText(forValue value: Float) -> String {
        return "\(Int(value))"
    }
    
    
    
    init(filter: Filter) {
        self.filter = filter
    }
    
}
