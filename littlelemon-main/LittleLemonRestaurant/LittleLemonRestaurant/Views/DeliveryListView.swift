import SwiftUI

struct DeliveryListView: View {
    
    private let categories = ["Starters", "Mains", "Desserts", "Drinks"]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 10) {
            Text("ORDER FOR DELIVERY!")
                .font(.title3)
                .fontWeight(.bold)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(categories, id: \.self) { category in
                        Text(category)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color("primary-color").opacity(0.2))
                            .foregroundStyle(Color("primary-color"))
                            .cornerRadius(10)
                            .font(.system(size: 14, weight: .bold))
                    }
                }
            }
        }
        .padding([.leading, .trailing], 20)
        .padding([.top, .bottom], 10)
    }
}

#Preview {
    DeliveryListView()
}
