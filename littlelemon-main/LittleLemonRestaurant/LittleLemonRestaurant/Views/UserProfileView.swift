import SwiftUI

struct UserProfileView: View {
    let persistenceController = PersistenceController.shared
    
    @Environment(\.presentationMode) var presentation
    
    @AppStorage(kIsLoggedIn) var isLoggedIn : Bool = true
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var showRemoveAlert = false
    @State private var showChangeAlert = false
    @State private var showSaveAlert = false
    
    @State private var emailNotificationOptions = [
        (title: "Order updates", isOn: true),
        (title: "Password changes", isOn: true),
        (title: "Special offers", isOn: true),
        (title: "Newsletter", isOn: true)
    ]
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0) {
                HStack {
                    Button(action: {
                        self.presentation.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(width: 35, height: 35)
                            .background(Circle().fill(Color("primary-color")))
                    }
                    
                    Spacer()
                    Image("logo_img")
                        .imageScale(.large)
                        .scaledToFit()
                        .frame(
                            width: 150,
                            height: 50,
                            alignment: .center
                        )
                    
                    Spacer()
                    Image("profile-image-placeholder")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .padding([.leading, .trailing], 25)
                
                VStack(alignment: .leading) {
                    HStack {
                        Text("Personal information")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                    }
                    
                    
                    Text("Avatar")
                        .font(.caption)
                        .foregroundStyle(Color("primary-color"))
                    
                    HStack(spacing: 15) {
                        Image("profile-image-placeholder")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .animation(.easeInOut(duration: 0.3), value: true)
                        
                        Button("Change") {
                            showChangeAlert = true
                        }
                        .alert("", isPresented: $showChangeAlert) {
                            Button("OK", role: .cancel) {
                                showChangeAlert = false
                            }
                        } message: {
                            Text("Change button clicked")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .background(Color("primary-color"))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        
                        Button("Remove") {
                            showRemoveAlert = true
                        }
                        .alert("", isPresented: $showRemoveAlert) {
                            Button("OK", role: .cancel) {
                                showRemoveAlert = false
                            }
                        } message: {
                            Text("Remove button clicked")
                        }
                        
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 14)
                        .foregroundStyle(._333)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("primary-color"), lineWidth: 1)
                        )
                    }
                    .animation(.easeInOut(duration: 0.3), value: true)
                    
                    
                    VStack (alignment: .leading, spacing: 2) {
                        Text("First name")
                            .font(.caption)
                            .foregroundStyle(._333)
                        
                        TextField("", text: $firstName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 34)
                    }
                    .padding(.top, 10)
                    
                    VStack (alignment: .leading, spacing: 2) {
                        Text("Last name")
                            .font(.caption)
                            .foregroundStyle(._333)
                        
                        TextField("", text: $lastName)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 34)
                    }
                    .padding(.top, 10)
                    
                    VStack (alignment: .leading, spacing: 2) {
                        Text("Email")
                            .font(.caption)
                            .foregroundStyle(._333)
                        
                        TextField("", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 34)
                    }
                    .padding(.top, 10)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Phone number")
                            .font(.caption)
                            .foregroundStyle(._333)
                        
                        TextField("", text: $phoneNumber)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(height: 34)
                            .keyboardType(.numberPad)
                    }
                    .padding(.top, 10)
                    
                    Text("Email notifications")
                        .font(.headline)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                        .padding(.bottom, 1)
                    
                    ForEach(emailNotificationOptions.indices, id: \.self) { index in
                        Toggle(isOn: $emailNotificationOptions[index].isOn) {
                            Text(emailNotificationOptions[index].title)
                                .font(.footnote)
                                .padding([.leading,.bottom],3)
                        }
                        .toggleStyle(CheckboxToggleStyle())
                    }
                    
                    
                    Button("Log out") {
                        isLoggedIn = false
                        UserDefaults.standard.set(false, forKey: kIsLoggedIn)
                        PersistenceController.shared.clear()
                    }
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color("yellow-color"))
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                    .padding(.vertical, 15)
                    
                    HStack(alignment: .center, spacing: 10) {
                        Button("Discard changes") {
                            self.presentation.wrappedValue.dismiss()
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(Color(._333))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color("primary-color"), lineWidth: 1)
                        )
                        
                        Button("Save changes") {
                            showSaveAlert = true
                            UserDefaults.standard.set(firstName, forKey: kFirstName)
                            UserDefaults.standard.set(lastName, forKey: kLastName)
                            UserDefaults.standard.set(email, forKey: kEmail)
                            UserDefaults.standard.set(phoneNumber, forKey: kPhoneNumber)
                        }
                        .alert("", isPresented: $showSaveAlert) {
                            Button("OK", role: .cancel) {
                                showSaveAlert = false
                                self.presentation.wrappedValue.dismiss()
                            }
                        } message: {
                            Text("Changes saved successfully")
                        }
                        .font(.system(size: 14, weight: .semibold))
                        .padding(.horizontal, 18)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(Color("primary-color"))
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                }
                .padding()
                .background(Color(.systemGroupedBackground))
                .cornerRadius(15)
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
        } .onAppear(perform: {
            
            loadUserData()
            
        })
    }
    
    func loadUserData() {
        firstName = UserDefaults.standard.string(forKey: kFirstName) ?? ""
        lastName = UserDefaults.standard.string(forKey: kLastName) ?? ""
        email = UserDefaults.standard.string(forKey: kEmail) ?? ""
        phoneNumber = UserDefaults.standard.string(forKey: kPhoneNumber) ?? ""
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundStyle(configuration.isOn ? Color("primary-color") : .secondary)
                    .fontWeight(.bold)
                
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    UserProfileView()
}
