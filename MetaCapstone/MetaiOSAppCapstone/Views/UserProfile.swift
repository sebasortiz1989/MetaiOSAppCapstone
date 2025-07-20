//
//  UserProfile.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 12/07/25.
//

import SwiftUI

struct UserProfile: View {
    @Environment(\.presentationMode) var presentation
    @State var firstName = ""
    @State var lastName = ""
    @State var email = ""
    @State var phoneNumber = ""
    
    @State private var emailNotificationOptions = [
        (title: "Order updates", isOn: true),
        (title: "Password changes", isOn: true),
        (title: "Special offers", isOn: true),
        (title: "Newsletter", isOn: true)
    ]
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Circle().fill(Color.primary1))
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                Image("littleLemonLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50, alignment: .center)
                    .padding()
                
                HStack {
                    Spacer()
                    
                    NavigationLink(destination: UserProfile()) {
                        Image("profile-image-placeholder2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)
            }
            .padding(.bottom, -30)
       
            VStack {
                HStack {
                    Text("Personal information")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                }
                .padding()
             
                HStack {
                    VStack {
                        Text("Avatar")
                            .font(.paragraphText16)
                            .foregroundStyle(Color.primary1)
                        
                        Image("profile-image-placeholder2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    }
                    
                    CustomButton(
                        title: "Change",
                        action: {
                        },
                        backgroundColor: Color.primary1,
                        textColor: .white,
                        minWidth: 100)

                    CustomButton(
                        title: "Remove",
                        action: {
                        },
                        backgroundColor: .clear,
                        minWidth: 100)
    
                    
                    Spacer()
                }
                .padding(.horizontal)
                
                CustomTextField(placeholder: "First Name", text: $firstName)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                CustomTextField(placeholder: "Last Name", text: $lastName)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                CustomTextField(placeholder: "Email", text: $email, keyboardType: .emailAddress)
                    .padding(.horizontal)
                    .padding(.bottom, 5)
                CustomTextField(placeholder: "Phone Number", text: $phoneNumber, keyboardType: .phonePad)
                    .padding(.horizontal)
                
                Text("Email notifications")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 1)
                
                ForEach(emailNotificationOptions.indices, id: \.self) { index in
                    HStack {
                        CustomToggleButton(
                            isOn: $emailNotificationOptions[index].isOn,
                            title: emailNotificationOptions[index].title)
                        
                        Spacer()
                    }
                }
                
                CustomButton(
                    title: "Log Out",
                    action: {
                        UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                        self.presentation.wrappedValue.dismiss()
                    },
                    minWidth: 350)
                .padding()
                
                HStack {
                    CustomButton(
                        title: "Discard Changes",
                        action: {
                        },
                        backgroundColor: .clear,
                        minWidth: 190)
                    
                    CustomButton(
                        title: "Save Changes",
                        action: {
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(phoneNumber, forKey: kphoneNumber)
                        },
                        backgroundColor: Color.primary1,
                        textColor: .white,
                        minWidth: 160)
                }
                .padding(.bottom, 15)
                .padding(.horizontal)
            }
            .padding()
            
            Spacer()
        }
        .onAppear() {
            firstName = UserDefaults.standard.string(forKey: kFirstName) ?? "Seba"
            lastName = UserDefaults.standard.string(forKey: kLastName) ?? "Ortiz"
            email = UserDefaults.standard.string(forKey: kEmail) ?? "seba@gmail.com"
            phoneNumber = UserDefaults.standard.string(forKey: kphoneNumber) ?? "+55 55 555 5555"
        }
    }
}

#Preview {
    UserProfile()
}
