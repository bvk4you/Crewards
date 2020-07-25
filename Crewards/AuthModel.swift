//
//  ViewModel.swift
//  Crewards
//
//  Created by vabhaske on 21/07/20.
//

import Foundation
import Combine
import Firebase
class AuthModel: ObservableObject{
    @Published var isLoggedIn: Bool = false
        
    func verifyNumber() -> Void {
        if Auth.auth().currentUser != nil
        {
            try? Auth.auth().signOut()
            return
        }
        PhoneAuthProvider.provider().verifyPhoneNumber("+919876543210", uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print(error.localizedDescription)
            return
          }
          // Sign in using the verificationID and the code sent to the user
          // ...
            self.SignIn(verificationID:verificationID!,verificationCode:"123456")
        }
        
    }
    
    func SignIn(verificationID: String, verificationCode: String) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            print("Sigin Failed \(authError)")
            return;
          }
            print("Siginin succeeded \(String(describing: authResult))")
        }
    }
}
