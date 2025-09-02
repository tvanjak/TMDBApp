import SwiftUI


struct CustomTextField: View {
    @Binding var text: String
    var subtitle: String
    var placeholder: String
    var secure: Bool

    var body: some View {
        VStack (alignment: .leading){
            Text(subtitle)
                .foregroundStyle(.white)
                .font(.headline)
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 21/255, green: 77/255, blue: 133/255))
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(red: 76/255, green: 178/255, blue: 223/255))
                        .font(.title3)
                        .padding(.horizontal)
                }
                
                if secure {
                    SecureField("", text: $text)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding(.horizontal, 16)
                } else {
                    TextField("", text: $text)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding(.horizontal, 16)
                }
            }
            .frame(height: 55)
            .frame(maxWidth: .infinity)
        } .padding(.horizontal)

    }
}


struct CustomPasswordTextField: View {
    @Binding var text: String
    var subtitle: String
    var placeholder: String
    var secure: Bool
    
    var forgotPasswordAction: (() -> Void)

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text(subtitle)
                    .foregroundStyle(.white)
                    .font(.headline)
                Button("Forgot your password?", action: forgotPasswordAction)
                    .padding(.leading, 90)
                    .foregroundColor(Color(red: 76/255, green: 178/255, blue: 223/255))
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(red: 21/255, green: 77/255, blue: 133/255))
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(Color(red: 76/255, green: 178/255, blue: 223/255))
                        .font(.title3)
                        .padding(.horizontal)
                }
                
                if secure {
                    SecureField("", text: $text)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding(.horizontal, 16)
                } else {
                    TextField("", text: $text)
                        .foregroundStyle(.white)
                        .font(.title3)
                        .padding(.horizontal, 16)
                }
            }
            .frame(height: 55)
            .frame(maxWidth: .infinity)
        } .padding(.horizontal)

    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(.blue) // Customize color
                    .font(.title2)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CustomDivider: View {
    var body: some View {
        Rectangle()
            .frame(height: 1)
            .padding(.horizontal)
            .foregroundColor(Color(red: 76/255, green: 178/255, blue: 223/255))
    }
}
