//
//  UserProfile.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 12/07/25.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) private var dismiss
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: kIsLoggedIn)
    
    var body: some View {
        VStack {
            Text("Personal information")
            Image("profile-image-placeholder")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .clipShape(Circle())
       
            let firstName = UserDefaults.standard.string(forKey: kFirstName) ?? "Seba"
            let lastName = UserDefaults.standard.string(forKey: kLastName) ?? "Ortiz"
            let email = UserDefaults.standard.string(forKey: kEmail) ?? "seba@gmail.com"

            Text(firstName)
            Text(lastName)
            Text(email)
            
            CustomButton(
                title: "LogOut",
                action: {
                    UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                    isLoggedIn = false
                    dismiss()
                },
                minWidth: 150)
                .padding()
            
            Spacer()
        }
        .onChange(of: isLoggedIn) { newValue in
            presentationMode.wrappedValue.dismiss()
        }
    }
}

#Preview {
    UserProfile()
}
