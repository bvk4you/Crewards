//
//  SortFilterData.swift
//  Crewards
//
//  Created by vabhaske on 06/08/20.
//

import Foundation
struct SortFilterItem :Decodable{
    var name : String
    var options : [String]
    var isSingleSelection: Bool
    var title: String
}
struct SortFilterModel :Decodable{
    var selectedCategory : SortFilterItem
    var allItems:[SortFilterItem]
}
struct SortFilterState:Decodable,Equatable {
    var sortOn = "id"
    var source = "server"
    var categoryOptions = [CardCategory]()
    var benefitsOptions = [BenefitsCategory]()
    var rewardRange = 0.0
    //var categoryFilters:[String]
    
}

 
