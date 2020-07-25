//
//  PhoneSignInView.swift
//  Crewards
//
//  Created by vabhaske on 22/07/20.
//

import SwiftUI

struct PhoneSignInView: View {
        
        @State var phone: String = ""
        @ObservedObject var textBindingManager = TextBindingManager(limit: 10)
        @ObservedObject var otpBindingManager = TextBindingManager(limit: 6)


       

    @EnvironmentObject var session : SessionStore
    @Environment(\.colorScheme) var colorScheme
        func signIn () {
                    }
        var body: some View {
            Group {
                content
                    .navigationBarTitle("Crewards")
            }
        }
        
        private var content: some View {
            switch session.state {
            case .idle:
                return GetOTPView(isLoading:false).eraseToAnyView()
            case .requestedOTP:
                return GetOTPView(isLoading:true).eraseToAnyView()

            case .OTPRequestFailed:
                return GetOTPView(isLoading:false).eraseToAnyView()
            case .OTPReceived:
                return GetValidationView(isLoading: false).eraseToAnyView()
            case .requestedValidation:
                return GetValidationView(isLoading: true).eraseToAnyView()
            case .validationFailed:
                return GetValidationView(isLoading :false).eraseToAnyView()
            case .validationSuccess:
                return AppView().eraseToAnyView()

            }
        }
    
    func GetValidationView(isLoading:Bool) -> some View {
        GeometryReader { geo in
            
            ZStack{
                RadialGradient(gradient: Gradient(colors: [Color.black, Color.gray]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/, endRadius: /*@START_MENU_TOKEN@*/500/*@END_MENU_TOKEN@*/)
                VStack {
                    Group {
                        Image("cardshome2")
                            .resizable()
                            .aspectRatio(contentMode:.fit)
                            .frame(width:geo.size.width,height:geo.size.height/4)
                        
                        Text("Crewards").font(.title).foregroundColor(.white)
                            .padding(.top, 1)
                        
                        
                        Text("The easiest way to find the best Credit cards!")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .lineLimit(nil)
                            .multilineTextAlignment(.center)
                            .padding(.top, 10)
                            
                            .padding(.bottom, 20)
                    }
                    
                    
                    
                    Group {
                        
                        CustomInput(text: self.$otpBindingManager.text, name: "123456")
                            .padding(.bottom,geo.size.height/8)
                            .padding(.leading,30)
                            .foregroundColor(.white)
                            .background(Color.clear)
                        
                        //                    CustomInput(text: self.$otpBindingManager.text, name: "Enter OTP")
                        //                        .padding()
                        //                        .foregroundColor(self.colorScheme == .dark ? .white : .black)
                        //                        .background(self.colorScheme == .dark ? Color.gray : .white)
                        
                        
                        
                        if (self.session.state == .validationFailed) {
                            InlineAlert(
                                title: "Hmm... That didn't work.",
                                subtitle: "Please check your code and try again"
                            ).padding([.horizontal, .top])
                            
                        }
                        
                        CustomButton(
                            label: "Sign in",
                            action: {
                                self.session.phoneSignIn(verificationCode: self.otpBindingManager.text){ authrsult, error in
                                    
                                }
                        },
                            loading: isLoading ||
                                self.otpBindingManager.text.count < 6
                        )
                            .padding(.bottom,geo.size.height/8)
                            .disabled(isLoading)
                    }
                }
                if(isLoading) {
                    Spinner(isAnimating: true, style: .large)
                }
            }
        }
        
    }

    func GetOTPView(isLoading:Bool) -> some View {
        GeometryReader { geo in

        ZStack {
            RadialGradient(gradient: Gradient(colors: [Color.black, Color.gray]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: 0, endRadius: /*@START_MENU_TOKEN@*/500/*@END_MENU_TOKEN@*/)
            VStack(alignment: .center, spacing: 0.0) {
                ExtractedView(width:geo.size.width,height:geo.size.height/4)
                    .padding(.top, 0.0)
                            
                    
                    Group {
                        
                        CustomInput(text: self.$textBindingManager.text, name: "9999999999")
                            .padding(.bottom,geo.size.height/8)
                            .padding(.horizontal, 50.0)
                            .foregroundColor(.white)
                            .background(Color.clear)
                            .frame(width: 300, height: 100, alignment: .center)
                        
                        
                        
                        if (self.session.state == .OTPRequestFailed) {
                            InlineAlert(
                                title: "Hmm... That didn't work.",
                                subtitle: "Please check your number and try again"
                            ).padding([.horizontal, .top])
                            
                        }
                        
                        CustomButton(
                            label: "  Get OTP  ",
                            action: {
                                self.session.getOTP(phoneNumber: "+91\(self.textBindingManager.text)") { result, error in
                                    
                                    
                                }
                        },
                            loading: isLoading || self.textBindingManager.text.count < 10
                            
                        )
                            .padding(.bottom,geo.size.height/8)
                            .disabled(self.textBindingManager.text.count < 10)
                    }
                    .padding(.top, 100.0)
                }
            .padding(.top, 0.0)
                
                if(isLoading) {
                    Spinner(isAnimating: true, style: .large)
                }
                
        }
        }
    }
}

struct PhoneSignInView_Previews: PreviewProvider {
    @EnvironmentObject var session : SessionStore

    static var previews: some View {
        PhoneSignInView()
    }
}

struct ExtractedView: View {
    var width:CGFloat
    var height: CGFloat
    var body: some View {
        Group {
        Image("cardshome2")
            .padding(.top,0.0)
            .frame(width:width,height: height)
            .shadow(radius: 20)
            .background(Color.clear)
            .cornerRadius(20)
            .shadow(radius: 20)
        
        Text("Crewards").font(.title).foregroundColor(.white)
        
        
        Text("The easiest way to find the best Credit cards!")
            .font(.subheadline)
            .foregroundColor(.gray)
            .lineLimit(nil)
            .multilineTextAlignment(.center)
        }
    }
    
}
