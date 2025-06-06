import SwiftUI

struct UserInfoView: View {
    @EnvironmentObject var onboardingState: OnboardingState
    @FocusState private var focusedField: Field?
    
    private enum Field {
        case name, age
    }
    
    var body: some View {
        VStack(spacing: Theme.padding24) {
            Text("Tell us about yourself")
                .font(Theme.titleFont)
                .foregroundColor(Theme.textColor)
                .multilineTextAlignment(.center)
                .padding(.top, Theme.padding32)
            
            VStack(spacing: Theme.padding16) {
                TextField("Your name", text: $onboardingState.name)
                    .textFieldStyle(CustomTextFieldStyle())
                    .focused($focusedField, equals: .name)
                    .submitLabel(.next)
                    .onSubmit {
                        focusedField = .age
                    }
                
                TextField("Your age", text: $onboardingState.age)
                    .textFieldStyle(CustomTextFieldStyle())
                    .keyboardType(.numberPad)
                    .focused($focusedField, equals: .age)
                    .submitLabel(.done)
                    .onSubmit {
                        focusedField = nil
                    }
            }
            .padding(.horizontal, Theme.padding24)
            
            Spacer()
            
            Button("Next") {
                onboardingState.navigateTo(.calculating)
            }
            .primaryButton()
            .padding(.horizontal, Theme.padding24)
            .padding(.bottom, Theme.padding32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundColor)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button(action: {
                    focusedField = nil
                }) {
                    Text("Done")
                }
            }
        }
    }
}

struct CustomTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(Theme.padding16)
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
            .foregroundColor(Theme.textColor)
            .font(Theme.bodyFont)
    }
}

#Preview {
    UserInfoView()
        .environmentObject(OnboardingState())
} 