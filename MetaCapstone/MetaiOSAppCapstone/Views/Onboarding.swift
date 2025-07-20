//
//  Onboarding.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 29/06/25.
//

import SwiftUI

let kFirstName = "Seba"
let kLastName = "Ortiz"
let kEmail = "seba@gmail.com"
let kphoneNumber = "+55 55 555 5555"
let kIsLoggedIn = "kIsLoggedIn"

struct Onboarding: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var isLoggedIn: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Image("littleLemonLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .padding()
                
                LittleLemonTitleView()
                CustomTextField(placeholder: "First Name", text: $firstName)
                
                CustomTextField(placeholder: "Last Name", text: $lastName)
                
                CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                
                Spacer()
                
                CustomButton(
                    title: "Register",
                    action: {
                        if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                            if isValidEmail(email) {
                                UserDefaults.standard.set(firstName, forKey: kFirstName)
                                UserDefaults.standard.set(lastName, forKey: kLastName)
                                UserDefaults.standard.set(email, forKey: kEmail)
                                
                                print("Registration successful!")
                                isLoggedIn = true // Set isLoggedIn to true
                            } else {
                                print("Invalid email")
                                isLoggedIn = false
                            }
                        } else {
                            print("Please fill in all fields")
                            isLoggedIn = false
                        }
                        
                        UserDefaults.standard.set(isLoggedIn, forKey: kIsLoggedIn)
                    },
                    minWidth: 350
                )
                
                Spacer()
            }
            .padding()
            .onAppear(perform: {
                isLoggedIn = UserDefaults.standard.bool(forKey: kIsLoggedIn)
            })
            .navigationDestination(isPresented: $isLoggedIn) {
                Home().navigationBarBackButtonHidden(true)
            }
        }
    }
    
    // Optional: Email validation function
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}

#Preview {
    Onboarding()
}
