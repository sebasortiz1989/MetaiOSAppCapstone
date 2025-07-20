import SwiftUI

struct CustomToggleButton: View {
    @Binding var isOn: Bool
    let title: String
    
    var body: some View {
        Button {
            isOn.toggle()
        } label: {
            HStack {
                Image(systemName: isOn ? "checkmark.square.fill" : "square")
                    .font(.title2)
                    .foregroundColor(.primary)
                if !title.isEmpty {
                    Text(title)
                        .font(.paragraphText16)
                        .foregroundColor(.primary)
                }
                
            }
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CustomToggleButton(isOn: .constant(true), title: "Accept Terms")
}
