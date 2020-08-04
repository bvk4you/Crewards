//
//  Session.swift
//  julienne
//
//  Created by Ben McMahen on 2019-06-27.
//  Copyright © 2019 Ben McMahen. All rights reserved.
//

import SwiftUI
import Foundation
import Firebase
import Combine

// TODO: Google sign in:
// https://firebase.google.com/docs/auth/ios/google-signin

struct User {
    var uid: String
    var email: String?
    var photoURL: URL?
    var displayName: String?
    
    static let `default` = Self(
        uid: "sdfdsaf",
        displayName: "Ben McMahen",
        email: "ben.mcmahen@gmail.com",
        photoURL: nil
    )

    init(uid: String, displayName: String?, email: String?, photoURL: URL?) {
        self.uid = uid
        self.email = email
        self.photoURL = photoURL
        self.displayName = displayName
    }
}


extension SessionStore {
    enum State : Equatable {
        case config
        case idle
        case requestedOTP
        case OTPRequestFailed
        case OTPReceived
        case requestedValidation
        case validationFailed
        case validationSuccess
    }

    enum Event {
        case onAppear
        case onSelectMovie(Int)
        case onFailedToLoadMovies(Error)
        case onGetOTP(String)
        case onOTPReceived
        case onOTPError(String)
        case onValidateOTP(String)
    }
}
   
/**
 * SessionStore manages the firebase user session. It contains the current user. It
 * also provides functions for signing up, signing in, etc.
 */

class SessionStore : ObservableObject {
    @Published private(set) var state = State.idle
    var didChange = PassthroughSubject<SessionStore, Never>()
    @Published var session: User? { didSet { self.didChange.send(self) }}
    private var verificationID: String?

    var handle: AuthStateDidChangeListenerHandle?
    
    private var bag = Set<AnyCancellable>()
    
    private let input = PassthroughSubject<Event, Never>()
    
    init() {
        self.state = .config
    }
    
    
    
   
    init(session: User? = nil) {
        self.session = session
    }
    
    func listen () {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("Got user \(user)")
                self.session = User(
                    uid: user.uid,
                    displayName: user.displayName,
                    email: user.email,
                    photoURL: user.photoURL
                )
            } else {
                self.session = nil
                self.state = State.idle
            }
        }
    }
    
    
    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
//            self.isLoggedIn = false
//            self.session = nil
            return true
        } catch {
            return false
        }
    }
    
    // stop listening for auth changes
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    deinit {
        unbind()

    }
    
    func signUp(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }
    
    func signIn(
        email: String,
        password: String,
        handler: @escaping AuthDataResultCallback
        ) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    func getOTP(phoneNumber: String, completion: @escaping (String?,Error?) -> Void) -> Void {
        print("getOTP phoneNumber:\(phoneNumber)")
        self.state = State.requestedOTP

        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            print(error.localizedDescription)
            completion(verificationID,error)
            self.state = State.OTPRequestFailed

            return
          }
          // Sign in using the verificationID and the code sent to the user
          // ...
            self.verificationID = verificationID
            self.state = State.OTPReceived

        }
        
    }
    
    func phoneSignIn(verificationCode: String, completion:@escaping (AuthDataResult?, Error?) -> Void) {
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: self.verificationID!,
            verificationCode: verificationCode)
        self.state = State.requestedValidation
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            print("Sigin Failed \(authError)")
            completion(authResult,authError)
            self.state = State.validationFailed

            return;
          }
            print("Siginin succeeded \(String(describing: authResult))")
            completion(authResult,error)
            self.state = State.validationSuccess


        }
    }
}

