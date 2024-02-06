//
//  QuizApp.swift
//  Quiz
//
//  Created by Tung Vu Duc on 06/02/2024.
//

import SwiftUI

@main
struct QuizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(questions: [
                Question(options: ["Lemon", "Orange", "Banana", "Strawberry"], answer: "Orange"),
                Question(options: ["Porsche", "Ferarri", "Tesla", "Vinfast"], answer: "Vinfast"),
                Question(options: ["Dog", "Cat", "Moschique", "Bird"], answer: "Bird")
            ]))
        }
    }
}
