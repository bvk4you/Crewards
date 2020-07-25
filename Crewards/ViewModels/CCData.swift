//
//  CCData.swift
//  Crewards
//
//  Created by vabhaske on 21/07/20.
//

import Foundation
import Combine
import Firebase
class CCData: ObservableObject{
    var ref: DatabaseReference  = Database.database().reference()

    
    func load()
    {
        ref.observe(.value ) { (snapshot) in
          // Get user value
            
          let value = snapshot.value as? NSDictionary
            for child in snapshot.children {
                print("child  \(child)")
             }
            print("database returned \(value)")
          // ...
          }
    }
    
}
