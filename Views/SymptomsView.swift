import SwiftUI

struct SymptomsView: View {
    let categoryId: Int
    @EnvironmentObject var onboardingState: OnboardingState
    
    private var category: SymptomCategory {
        symptomCategories[categoryId - 1]
    }
    
    var body: some View {
        VStack(spacing: Theme.padding24) {
            Text(category.title)
                .font(Theme.titleFont)
                .foregroundColor(Theme.textColor)
                .multilineTextAlignment(.center)
                .padding(.top, Theme.padding32)
            
            Text("Select all that apply")
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textColor.opacity(0.8))
            
            ScrollView {
                VStack(spacing: Theme.padding12) {
                    ForEach(category.symptoms, id: \.self) { symptom in
                        SymptomButton(
                            symptom: symptom,
                            isSelected: onboardingState.selectedSymptoms.contains(symptom)
                        ) {
                            if onboardingState.selectedSymptoms.contains(symptom) {
                                onboardingState.selectedSymptoms.remove(symptom)
                            } else {
                                onboardingState.selectedSymptoms.insert(symptom)
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.padding24)
            }
            
            Button(categoryId == symptomCategories.count ? "Reboot My Brain" : "Next") {
                if categoryId == symptomCategories.count {
                    onboardingState.navigateTo(.educational)
                } else {
                    onboardingState.navigateTo(.symptoms(categoryId + 1))
                }
            }
            .primaryButton()
            .padding(.horizontal, Theme.padding24)
            .padding(.bottom, Theme.padding32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Theme.backgroundColor)
    }
}

struct SymptomButton: View {
    let symptom: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(symptom)
                    .font(Theme.bodyFont)
                    .foregroundColor(Theme.textColor)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(Theme.primaryColor)
                }
            }
            .padding(Theme.padding16)
            .background(Theme.secondaryBackgroundColor)
            .cornerRadius(Theme.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: Theme.cornerRadius)
                    .stroke(isSelected ? Theme.primaryColor : Color.clear, lineWidth: 1)
            )
        }
    }
}

#Preview {
    SymptomsView(categoryId: 1)
        .environmentObject(OnboardingState())
} 