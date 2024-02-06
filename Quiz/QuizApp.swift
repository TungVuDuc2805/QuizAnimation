//
//  QuizApp.swift
//  Quiz
//
//  Created by Tung Vu Duc on 06/02/2024.
//

import SwiftUI

let questions = [
    Question(title: "Which option that describes the image best?", image: "sports-car", options: ["Car", "Airplane", "Motorbike", "Bicycle"], answer: "Car"),
    Question(title: "Which option that describes the image best?", image: "orange",options: ["Strawberry", "Apple", "Orange", "Carrot"], answer: "Orange"),
    Question(title: "Which option that describes the image best?", image: "cow", options: ["Tiger", "Cow", "Dog", "Deer"], answer: "Cow"),
    Question(title: "Which option that describes the image best?", image: "burger", options: ["Food", "Fruit", "Animal", "Book"], answer: "Food")
]

@main
struct QuizApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ContentViewModel(questions: questions))
        }
    }
}
