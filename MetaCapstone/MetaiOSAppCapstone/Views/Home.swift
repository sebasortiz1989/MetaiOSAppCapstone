//
//  Home.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 02/07/25.
//

import SwiftUI

struct Home: View {
    @Environment(\.presentationMode) var presentationMode
    let persistenceController = PersistenceController.shared
    private let categories = ["Starters", "Mains", "Desserts", "Drinks"]

    @State private var searchText: String = ""

    var body: some View {
        NavigationView {
            ScrollView  {
                VStack {
                    ZStack {
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
                        }
                        .padding(.trailing)
                    }
                  
                    ZStack(alignment: .bottom) {
                        LittleLemonTitleView(isExpanded: .constant(true))
                        VStack {
                            HStack {
                                Image(systemName: "magnifyingglass")
                                    .foregroundColor(.gray)
                                TextField("Search", text: $searchText)
                                    .textFieldStyle(.plain)
                            }
                            .padding()
                            .frame(width: 350, height: 40)
                            .background(Color.white)
                            .clipShape(Capsule())
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.black, lineWidth: 1)
                            )
                        }
                        .padding(.bottom, 12)
                    }

                    VStack (alignment: .leading, spacing: 10) {
                        Text("ORDER FOR DELIVERY!")
                            .font(.sectionTitle20)
                        
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                Text(category)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.primary1.opacity(0.2))
                                    .foregroundStyle(Color.primary1)
                                    .cornerRadius(10)
                                    .font(.paragraphText16)
                                    .fontWeight(.regular)
                            }
                        }
                    }
                    .padding([.leading, .trailing], 20)
                    .padding([.top, .bottom], 10)
                    
                    Menu(searchText: $searchText)
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .frame(minHeight: 500)
                }
            }
        }
        .onAppear(perform: {
            if !UserDefaults.standard.bool(forKey: kIsLoggedIn) {
                presentationMode.wrappedValue.dismiss()
            }
        })
    }
}

#Preview {
    Home()
}
