import SwiftUI

struct QuizQuestionView: View {
    let question: QuizQuestion
    let selectedAnswer: Int?
    let onSelect: (Int) -> Void
    
    var body: some View {
        VStack(spacing: Theme.padding32) {
            // Question
            Text(question.question)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, Theme.padding24)
                .padding(.top, Theme.padding32)
            
            // Options
            VStack(spacing: Theme.padding16) {
                ForEach(question.options.indices, id: \.self) { index in
                    AnswerButton(
                        text: question.options[index],
                        number: index + 1,
                        isSelected: selectedAnswer == index,
                        action: { onSelect(index) }
                    )
                }
            }
            .padding(.horizontal, Theme.padding24)
            
            Spacer()
        }
        .backgroundGradient()
    }
}

struct AnswerButton: View {
    let text: String
    let number: Int
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: Theme.padding16) {
                // Numbered circle
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white : Color.white.opacity(0.1))
                        .frame(width: 32, height: 32)
                    
                    Text("\(number)")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? Color.black : Color.white)
                }
                
                Text(text)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                
                Spacer()
            }
            .padding(Theme.padding16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(isSelected ? Color.white.opacity(0.2) : Color.white.opacity(0.1))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.white : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Preview
struct QuizQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Preview first question
            QuizQuestionView(
                question: quizQuestions[0],
                selectedAnswer: nil,
                onSelect: { _ in }
            )
            .previewDisplayName("First Question")
            
            // Preview with selected answer
            QuizQuestionView(
                question: quizQuestions[1],
                selectedAnswer: 2,
                onSelect: { _ in }
            )
            .previewDisplayName("With Selection")
            
            // Preview different question types
            QuizQuestionView(
                question: quizQuestions[5],
                selectedAnswer: nil,
                onSelect: { _ in }
            )
            .previewDisplayName("Struggles Question")
            
            // Preview in dark mode
            QuizQuestionView(
                question: quizQuestions[0],
                selectedAnswer: nil,
                onSelect: { _ in }
            )
            .preferredColorScheme(.dark)
            .previewDisplayName("Dark Mode")
        }
    }
} 