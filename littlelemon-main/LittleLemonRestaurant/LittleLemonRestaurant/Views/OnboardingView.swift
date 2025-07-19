import SwiftUI


public let kFirstName: String = "first name key"
public let kLastName: String = "last name key"
public let kEmail: String = "email key"
public let kPhoneNumber: String = "phone number key"
public let kIsLoggedIn: String = "kIsLoggedIn"

struct OnboardingView: View {
    
    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var email: String = ""
    @AppStorage(kIsLoggedIn) var isLoggedIn : Bool = false
    
    var body: some View {
        NavigationView(content: {
            VStack(spacing: 20, content: {
                NavigationLink(destination: HomeView().navigationBarBackButtonHidden(true),
                               isActive: $isLoggedIn) {
                    EmptyView()
                }
                HStack(alignment: .top) {
                    Image("logo_img")
                        .imageScale(.large)
                        .foregroundStyle(.tint)
                        .frame(
                            width: 100,
                            height: 50,
                            alignment: .center
                        )
                }
                
                HeroView()
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("First Name*").foregroundStyle(._333).fixedSize()
                    TextField("", text: $firstName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 34)
                }
                
                VStack(alignment: .leading, spacing: 2) {
                    Text("Last Name*").foregroundStyle(._333).fixedSize()
                    TextField("", text: $lastName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 34)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text("Email*").foregroundStyle(._333).fixedSize()
                    TextField("", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(height: 34)
                }
                
                Button(
                    "Register",
                    action: {
                        if !firstName.isEmpty && !lastName.isEmpty
                            && !email.isEmpty
                        {
                            UserDefaults.standard.set(
                                firstName,
                                forKey: kFirstName
                            )
                            UserDefaults.standard.set(
                                lastName,
                                forKey: kLastName
                            )
                            UserDefaults.standard.set(email, forKey: kEmail)
                            
                            isLoggedIn = true
                            UserDefaults.standard.set(
                                isLoggedIn,
                                forKey: kIsLoggedIn
                            )
                        }
                    }
                ).font(.system(size: 14, weight: .semibold))
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity)
                    .background(Color("yellow-color"))
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                    .padding(.vertical, 15)
            }).padding(10)
        })
        .onAppear(perform: {
            isLoggedIn = UserDefaults.standard.bool(forKey: kIsLoggedIn)
        })
        
        .padding()
    }
}

#Preview {
    OnboardingView()
}
