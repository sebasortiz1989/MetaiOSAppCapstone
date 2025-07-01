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

struct Onboarding: View {
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    
    var body: some View {
        VStack(spacing: 20) {
            CustomTextField(placeholder: "First Name", text: $firstName)
            
            CustomTextField(placeholder: "Last Name", text: $lastName)
            
            CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
            
            CustomButton(title: "Register") {
                if !firstName.isEmpty && !lastName.isEmpty && !email.isEmpty {
                    // Optional: Add email validation here
                    if isValidEmail(email) {
                        UserDefaults.standard.set(firstName, forKey: kFirstName)
                        UserDefaults.standard.set(lastName, forKey: kLastName)
                        UserDefaults.standard.set(email, forKey: kEmail)
                        
                        // Here you would navigate to the Home screen
                        print("Registration successful!")
                    } else {
                        print("Invalid email")
                    }
                } else {
                    print("Please fill in all fields")
                }
            }
        }
        .padding()
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
