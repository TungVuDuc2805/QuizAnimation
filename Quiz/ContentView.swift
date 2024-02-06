//
//  ContentView.swift
//  Quiz
//
//  Created by Tung Vu Duc on 06/02/2024.
//

import SwiftUI

struct Question: Identifiable {
    let id: UUID = UUID()
    let image: String = "Orange_fruit_logo"
    let options: [String]
    let answer: String
}

class ContentViewModel: ObservableObject {
    let questions: [Question]
    @Published var selection: String? {
        didSet {
            checkAnswer()
        }
    }
    @Published var currentQuestion: (current: Question, next: Question?, nextNext: Question?)?
    @Published var shouldHighlightCorrectAnswer: String?
    private var currentQuestionIndex = 0
    
    init(questions: [Question]) {
        self.questions = questions
        getCurrentQuestion()
    }
    
    private func getCurrentQuestion() {
        if currentQuestionIndex < questions.count {
            let currentQuestion = questions[currentQuestionIndex]
            let nextQuestion: Question?
            if currentQuestionIndex+1 < questions.count {
                nextQuestion = questions[currentQuestionIndex+1]
            } else {
                nextQuestion = nil
            }
            let nextNextQuestion: Question?
            if currentQuestionIndex+2 < questions.count {
                nextNextQuestion = questions[currentQuestionIndex+2]
            } else {
                nextNextQuestion = nil
            }
            self.currentQuestion = (currentQuestion, nextQuestion, nextNextQuestion)
        } else {
            self.currentQuestion = nil
        }
    }
    
    func checkAnswer() {
        guard let answer = selection else {
            return
        }
        currentQuestionIndex += 1
        getCurrentQuestion()
        selection = nil
//        shouldHighlightCorrectAnswer = questions[currentQuestionId].answer
    }
}

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    init(viewModel: ContentViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.gray.opacity(0.2), radius: 5)
                    .tint(Color("TextColor"))
                    
                    Spacer()
                    
                    Circle()
                        .stroke(.gray.opacity(0.2), lineWidth: 6)
                        .frame(width: 45)
                        .overlay(
                            Circle()
                                .trim(from: 0, to: 0.5)
                                .stroke(.green, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                .frame(width: 45)
                                .rotationEffect(.degrees(-90))
                        )
                        .background(
                            Text("5")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color("TextColor"))
                        )
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark")
                            .fontWeight(.medium)
                    }
                    .padding()
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(color: Color.gray.opacity(0.2), radius: 5)
                    .tint(Color("TextColor"))
                }
                
                Text("What's the correct translation?")
                    .fontWeight(.medium)
                    .foregroundStyle(Color("TextColor"))
                    .padding(.top)
                
                
                Spacer()
                
                if let question = viewModel.currentQuestion {
                    QuestionView(question: question, publishSelection: $viewModel.selection)
                } else {
                    Button {
                        
                    } label: {
                        Text("Restart")
                    }
                    .buttonStyle(.bordered)

                }
                
                Spacer()
            }
            .padding()
        }
        .background(Color("PrimaryBackground"))
    }
}

struct QuestionView: View {
    let question: (current: Question, next: Question?, nextNext: Question?)
    @State var selection: String?
    @State private var showOptions = false
    @State var dismissQuestion: Bool = false
    @Binding var publishSelection: String?
    
    var body: some View {
        VStack {
            ZStack {
                if let next = question.nextNext {
                    Image(next.image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.gray.opacity(0.3), radius: 5)
                        .offset(y: dismissQuestion ? 15 : 30)
                        .scaleEffect(dismissQuestion ? 0.9 : 0.8)
                }
                if let next = question.next {
                    Image(next.image)
                        .resizable()
                        .aspectRatio(1, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .shadow(color: Color.gray.opacity(0.3), radius: 5)
                        .offset(y: dismissQuestion ? -10 : 15)
                        .scaleEffect(dismissQuestion ? 1 : 0.9)
                }
                
                Image(question.current.image)
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .offset(x: dismissQuestion ? 1000 : 0)
                    .shadow(color: Color.gray.opacity(0.3), radius: 5)
                    .offset(y: -10)
            }
            .padding(40)
            
            VStack(spacing: 15) {
                ForEach(question.current.options.indices, id: \.self) { index in
                    let option = question.current.options[index]
                    OptionButtonView(title: option, delay: 0.5 + Double(index)*0.2, selection: $selection, highlightAnswer: .constant(nil))
                }
            }
            .offset(y: showOptions ? 0 : 150)
        }
        .opacity(showOptions ? 1 : 0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1)) {
                showOptions = true
            }
        }
        .onChange(of: selection) { _ in
            withAnimation(.easeInOut(duration: 0.5).delay(1)) {
                dismissQuestion = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                publishSelection = selection
                dismissQuestion = false
            }
        }
    }
}

struct OptionButtonView: View {
    let title: String
    let delay: TimeInterval
    @Binding var selection: String?
    @Binding var highlightAnswer: String?
    @State var showAnimated: Bool = false
    
    var body: some View {
        Button {
            selection = title
        } label: {
            Text(title)
                .font(.system(.title3, weight: .medium))
                .foregroundStyle(Color.white)
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(getBackgroundColor())
        .clipShape(RoundedRectangle(cornerRadius: 30))
        .opacity(showAnimated ? 1 : 0)
        .scaleEffect(showAnimated ? 1 : 0.9)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5).delay(delay)) {
                showAnimated = true
            }
        }
//        .animation(.easeInOut(duration: 0.5).repeatCount(5, autoreverses: true), value: highlightAnswer)
    }
    
    func getBackgroundColor() -> Color {
        if let highlightAnswer = highlightAnswer {
            if title == highlightAnswer {
                return Color("CorrectButtonBackground")
            } else {
                if selection == title {
                    return Color("WrongButtonBackground")
                } else {
                    return Color("ButtonBackground")
                }
            }
        } else {
            return selection == title ? Color("CorrectButtonBackground") : Color("ButtonBackground")
        }
    }
    
    func getOpacity() -> CGFloat {
        if let highlightAnswer = highlightAnswer {
            if title == highlightAnswer {
                return 0
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
}

#Preview {
    ContentView(viewModel: ContentViewModel(questions: [
        Question(options: ["Lemon", "Orange", "Banana", "Strawberry"], answer: "Orange"),
        Question(options: ["Porsche", "Ferarri", "Tesla", "Vinfast"], answer: "Vinfast")
    ]))
}
