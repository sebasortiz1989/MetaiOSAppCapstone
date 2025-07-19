//
//  Home.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 02/07/25.
//

import SwiftUI

struct Home: View {
    let persistenceController = PersistenceController.shared

    var body: some View {
        NavigationStack {
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
                                Image("profile-image-placeholder")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                        }
                        .padding(.trailing)
                    }
                    
                    LittleLemonTitleView()
                        .padding()
                    
                    Spacer()
                    Menu().environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .frame(height: 400)
                }

            }

        }
    }
}

#Preview {
    Home()
}
