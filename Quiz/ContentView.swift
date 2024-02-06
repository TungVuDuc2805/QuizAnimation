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
    @Published var triple: (current: Question, next: Question?, nextNext: Question?)?
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
            self.triple = (currentQuestion, nextQuestion, nextNextQuestion)
        } else {
            self.triple = nil
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
                if let question = viewModel.triple {
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
