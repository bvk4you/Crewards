//
//  NumberTextFieldViewModel.swift
//  Crewards
//
//  Created by vabhaske on 24/07/20.
//


import Foundation
import UIKit
class TextBindingManager: ObservableObject {
    @Published var editingDone = false
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
            if text.count == characterLimit {
                editingDone = true
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    var characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}


