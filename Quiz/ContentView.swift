//
//  ContentView.swift
//  Quiz
//
//  Created by Tung Vu Duc on 06/02/2024.
//

import SwiftUI

struct Question: Identifiable, Equatable {
    let id: UUID = UUID()
    let image: String
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
    @Published var currentQuestionIndex = 0
    
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
        guard let _ = selection else {
            return
        }
        currentQuestionIndex += 1
        getCurrentQuestion()
        selection = nil
    }
    
    func restart() {
        currentQuestionIndex = 0
        getCurrentQuestion()
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
                if let question = viewModel.currentQuestion {
                    HStack {
                        Button {
                            
                        } label: {
                            Image(systemName: "chevron.left")
                                .fontWeight(.medium)
                        }
                        .frame(width: 45, height: 45)
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
                                    .trim(from: 0, to: CGFloat(Double(viewModel.currentQuestionIndex)/Double(viewModel.questions.count)))
                                    .stroke(.green, style: StrokeStyle(lineWidth: 6, lineCap: .round))
                                    .frame(width: 45)
                                    .rotationEffect(.degrees(-90))
                            )
                            .background(
                                Text("\(viewModel.currentQuestionIndex)")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color("TextColor"))
                            )
                            .animation(.easeInOut, value: viewModel.currentQuestionIndex)
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "xmark")
                                .fontWeight(.medium)
                        }
                        .frame(width: 45, height: 45)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(color: Color.gray.opacity(0.2), radius: 5)
                        .tint(Color("TextColor"))
                    }
                    
                    Text("Which option that describes the image best?")
                        .fontWeight(.medium)
                        .foregroundStyle(Color("TextColor"))
                        .padding(.top)
                    
                    
                    Spacer()
                    
                    QuestionView(question: question, publishSelection: $viewModel.selection)
                } else {
                    ZStack {
                        Button {
                            viewModel.restart()
                        } label: {
                            Text("Restart")
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .padding()
        }
        .background(Color("PrimaryBackground"))
    }
}

struct QuestionView: View {
    let question: (current: Question, next: Question?, nextNext: Question?)
    @State var selection: String?
    @State private var showQuestion: Bool = false
    @State var dismissQuestion: Bool = false
    @Binding var publishSelection: String?
    @State private var dimissOptions = false
    @State private var showAnswer = false
    
    var body: some View {
        VStack {
            ZStack {
                if let next = question.nextNext {
                    ImageQuestionView(image: next.image)
                        .offset(y: dismissQuestion ? 20 : 30)
                        .scaleEffect(dismissQuestion ? 0.9 : 0.8)
                }
                
                if let next = question.next {
                    ImageQuestionView(image: next.image)
                        .offset(y: dismissQuestion ? -10 : 20)
                        .scaleEffect(dismissQuestion ? 1 : 0.9)
                }
                
                ImageQuestionView(image: question.current.image)
                    .offset(x: dismissQuestion ? 1000 : 0)
                    .offset(y: -10)
            }
            .padding(40)

            VStack(spacing: 15) {
                ForEach(question.current.options.indices, id: \.self) { index in
                    let option = question.current.options[index]
                    OptionButtonView(
                        title: option,
                        correctAnswer: question.current.answer,
                        delay: 0.3 + Double(index)*0.15,
                        selection: $selection,
                        dismissOptions: $dimissOptions,
                        showAnswer: $showAnswer
                    )
                }
            }
            .offset(y: showQuestion ? 0 : 150)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.5)) {
                showQuestion = true
            }
        }
        .onChange(of: question.current) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                showQuestion = true
            }
        }
        .onChange(of: selection) { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showAnswer = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        dismissQuestion = true
                        dimissOptions = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        publishSelection = selection
                        dismissQuestion = false
                        dimissOptions = false
                        showQuestion = false
                        showAnswer = false
                    }
                }
            }
        }
    }
}

struct ImageQuestionView: View {
    let image: String
    
    var body: some View {
        ZStack {
            Color.white
            
            Image(image)
                .resizable()
                .aspectRatio(1, contentMode: .fit)
                .padding(30)
        }
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.gray.opacity(0.3), radius: 5)
    }
}

struct OptionButtonView: View {
    let title: String
    let correctAnswer: String
    let delay: TimeInterval
    @Binding var selection: String?
    @Binding var dismissOptions: Bool
    @Binding var showAnswer: Bool
    @State var showAnimated: Bool = false
    
    var body: some View {
        Button {
            selection = title
        } label: {
            Text(title)
                .font(.system(.title3, weight: .medium))
                .foregroundStyle(Color.white)
                .frame(height: 60)
                .frame(maxWidth: .infinity)
                .background(getBackgroundColor())
                .clipShape(RoundedRectangle(cornerRadius: 30))
        }
        .opacity(showAnimated ? 1 : 0)
        .scaleEffect(showAnimated ? 1 : 0.9)
        .onAppear {
            withAnimation(.easeInOut(duration: 0.3).delay(delay)) {
                showAnimated = true
            }
        }
        .onChange(of: dismissOptions) { _ in
            withAnimation(.easeInOut(duration: 0.3).delay(delay)) {
                showAnimated = !dismissOptions
            }
        }
    }
    
    func getBackgroundColor() -> Color {
        if showAnswer {
            if title == correctAnswer {
                return Color("CorrectButtonBackground")
            } else if selection == title && selection != correctAnswer {
                return Color("WrongButtonBackground")
            } else {
                return Color("ButtonBackground")
            }
        } else {
            return selection == title ? Color("CorrectButtonBackground") : Color("ButtonBackground")
        }
    }
}
