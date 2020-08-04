//
//  Collection+Ext.swift
//  Crewards
//
//  Created by vabhaske on 30/07/20.
//

import Foundation
extension Collection {
    //Designed for use with Dictionary and Array types
    var jsonData: Data? {
        return try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
    }
}
