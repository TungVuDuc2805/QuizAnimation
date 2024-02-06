//
//  QuizApp.swift
//  Quiz
//
//  Created by Tung Vu Duc on 06/02/2024.
//

import SwiftUI

@main
struct QuizApp: App {
    let questions = [
        Question(image: "sports-car", options: ["Car", "Airplane", "Motorbike", "Bicycle"], answer: "Car"),
        Question(image: "orange",options: ["Strawberry", "Apple", "Orange", "Carrot"], answer: "Orange"),
        Question(image: "cow", options: ["Tiger", "Cow", "Dog", "Deer"], answer: "Cow"),
        Question(image: "burger", options: ["Food", "Fruit", "Animal", "Book"], answer: "Food")
    ]
    
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(questions: questions))
        }
    }
}
