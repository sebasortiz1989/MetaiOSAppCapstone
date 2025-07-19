import SwiftUI

struct HeroView: View {
    var body: some View {
        VStack(alignment: .leading) {
                Text("Little Lemon")
                    .font(.system(size: 42))
                    .fontWeight(.bold)
                    .foregroundColor(Color("yellow-color"))
                Text("Chicago")
                    .font(.system(size: 28))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                HStack(alignment: .center, spacing: 15) {
                    Text("We are a family owned Mediterranean restaurant, focused on traditional recipes served with a modern twist.")
                        .font(.system(size: 16))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .lineSpacing(0)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.top, 4)
                    
                    Image("food_img_1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 140, height: 140)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 25)
            .padding(.vertical, 15)
            .background(Color("primary-color"))
        }
}

#Preview {
    HeroView()
}
