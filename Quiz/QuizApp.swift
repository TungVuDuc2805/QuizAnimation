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
                Question(image: "racing-car", options: ["Lemon", "Orange", "Banana", "Strawberry"], answer: "Orange"),
                Question(image: "sports-car",options: ["Porsche", "Ferarri", "Tesla", "Vinfast"], answer: "Vinfast"),
                Question(image: "Orange_fruit_logo", options: ["Dog", "Cat", "Moschique", "Bird"], answer: "Bird"),
                Question(image: "sports-car",options: ["Porsche", "Ferarri", "Tesla", "Vinfast"], answer: "Vinfast"),
                Question(image: "Orange_fruit_logo", options: ["Dog", "Cat", "Moschique", "Bird"], answer: "Bird")
            ]))
        }
    }
}
