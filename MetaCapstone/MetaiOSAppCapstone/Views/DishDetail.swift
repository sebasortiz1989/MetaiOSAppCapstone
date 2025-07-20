//
//  DishDetail.swift
//  MetaiOSAppCapstone
//
//  Created by Sebastian Ortiz on 20/07/25.
//

import SwiftUI

struct DishDetail: View {
    let dish: Dish
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(dish.title ?? "No Title")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            AsyncImage(url: URL(string: dish.image ?? "")) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .cornerRadius(10)
            } placeholder: {
                ProgressView()
            }
            
            Text("\(dish.dishDescription ?? "")")
                .font(.headline)
                .foregroundStyle(.secondary)
                .foregroundColor(.black)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
            
            Text("Price: $\(String(format: "%.2f", dish.price))")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(Color.primary1)
            
            Spacer()
        }
        .padding()
        .navigationTitle(dish.title ?? "Dish Details")
    }
}

//#Preview {
//    DishDetail(dish: Dish())
//}
