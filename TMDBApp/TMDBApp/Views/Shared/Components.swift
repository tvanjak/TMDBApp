import SwiftUI


struct SectionsBar<Section: Hashable & CaseIterable>: View {
    @Binding var selectedSection: Section
    let titles: (Section) -> String
    
    var body: some View {
        ScrollView (.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: AppTheme.Spacing.large) {
                ForEach(Array(Section.allCases), id: \.self) { section in
                    VStack(alignment: .center) {
                        Button {
                            selectedSection = section
                        } label: {
                            Text(titles(section))
                                .font(AppTheme.Typography.subtitle)
                                .foregroundStyle(.black)
                                .fontWeight(selectedSection == section ? .bold : .thin)
                        }
                        if selectedSection == section {
                            Rectangle()
                                .frame(height: 4)
                                .frame(maxWidth: .infinity)
                        }
                    }
                }
            }
            .fixedSize(horizontal: true, vertical: false)
            .padding(.vertical)
        }
    }
}


struct CustomTextField: View {
    @Binding var text: String
    var subtitle: String
    var placeholder: String
    var secure: Bool
    
    var forgotPasswordAction: (() -> Void)?

    var body: some View {
        VStack (alignment: .leading){
            HStack {
                Text(subtitle)
                    .foregroundStyle(.white)
                    .font(AppTheme.Typography.body)
                if let optionalFunction = forgotPasswordAction {
                    Button("Forgot your password?", action: optionalFunction)
                        .padding(.leading, 90)
                        .foregroundColor(AppTheme.Colors.lightBlue)
                }
            }
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(AppTheme.Colors.darkBlue)
                
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(AppTheme.Colors.lightBlue)
                        .font(AppTheme.Typography.subtitle)
                        .padding(.horizontal)
                }
                
                if secure {
                    SecureField("", text: $text)
                        .foregroundStyle(.white)
                        .font(AppTheme.Typography.subtitle)
                        .padding(.horizontal, AppTheme.Spacing.medium)
                } else {
                    TextField("", text: $text)
                        .foregroundStyle(.white)
                        .font(AppTheme.Typography.subtitle)
                        .padding(.horizontal, AppTheme.Spacing.medium)
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
                    .font(AppTheme.Typography.title2)
                configuration.label
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

