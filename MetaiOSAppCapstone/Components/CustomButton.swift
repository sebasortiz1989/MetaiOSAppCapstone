import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var backgroundColor: Color = .mint
    var textColor: Color = .black
    var width: CGFloat = 300
    var height: CGFloat = 50
    var font: Font = .title3
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(width: width, height: height)
                .background(backgroundColor)
                .foregroundColor(textColor)
                .font(font)
                .cornerRadius(20)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.black, lineWidth: 3)
                )
        }
    }
}

#Preview {
    CustomButton(title: "Example Button")
    {
        
    }
}
