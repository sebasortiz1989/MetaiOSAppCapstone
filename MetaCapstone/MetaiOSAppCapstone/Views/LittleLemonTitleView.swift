import SwiftUI

struct LittleLemonTitleView: View {
    @Binding var isExpanded: Bool
    
    init(isExpanded: Binding<Bool>? = nil) {
        self._isExpanded = isExpanded ?? .constant(false)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Little Lemon")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .foregroundColor(.primary2)
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
                
                Image("food1")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 140, height: 140)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
            }
            .padding(.bottom, isExpanded ? 50 : 0)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .background(Color.primary1)
        .cornerRadius(15)
    }
}

#Preview {
    LittleLemonTitleView()
        .padding()
}
