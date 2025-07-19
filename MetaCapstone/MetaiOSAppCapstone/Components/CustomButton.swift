import SwiftUI

struct CustomButton: View {
    let title: String
    let action: () -> Void
    var backgroundColor: Color = .primary2
    var textColor: Color = .black
    var font: Font = .title3
    var minWidth: CGFloat? = nil
    var minHeight: CGFloat? = nil
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .padding()
                .frame(minWidth: minWidth, minHeight: minHeight)
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
