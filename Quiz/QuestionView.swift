//    
// QuestionView.swift
// Quiz
// Created by Tung Vu Duc.
// Copyright © 2024. All rights reserved.
// 

import SwiftUI

struct QuestionView: View {
    let question: (current: Question, next: Question?, last: Question?)
    @State var selection: String?
    @State private var showQuestion: Bool = false
    @State var dismissQuestion: Bool = false
    @Binding var publishSelection: String?
    @State private var dimissOptions = false
    @State private var showAnswer = false
    @State private var firstLoad = false
    
    var body: some View {
        VStack {
            Text(question.current.title)
                .multilineTextAlignment(.center)
                .fontWeight(.medium)
                .foregroundStyle(Color.textColor)
                .padding(.top)
                .scaleEffect(firstLoad ? 1 : 0.9)

            Spacer()
            
            ZStack {
                if let last = question.last {
                    ImageQuestionView(image: last.image)
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
            .scaleEffect(firstLoad ? 1 : 0.9)
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
                firstLoad = true
            }
        }
        .onChange(of: question.current) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                showQuestion = true
            }
        }
        .onChange(of: selection) { _ in
            onSelectionChange()
        }
    }
    
    private func onSelectionChange() {
        if selection == question.current.answer {
            animateChanges()
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showAnswer = true
                }
                
                animateChanges()
            }
        }
    }
    
    private func animateChanges() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
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
