//    
// OptionButtonView.swift
// Quiz
// Created by Tung Vu Duc.
// Copyright © 2024. All rights reserved.
// 

import Foundation
import SwiftUI

struct OptionButtonView: View {
    let title: String
    let correctAnswer: String
    let delay: TimeInterval
    @Binding var selection: String?
    @Binding var dismissOptions: Bool
    @Binding var showAnswer: Bool
    @State var showAnimated: Bool = false
    @State var scale = false
    
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
        .buttonStyle(ScaleButtonStyle())
        .scaleEffect(scale ? 0.95 : 1)
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
                return Color.correctBackground
            } else if selection == title && selection != correctAnswer {
                return Color.wrongBackground
            } else {
                return Color.defaultButtonBackground
            }
        } else {
            return selection == title ? Color.correctBackground : Color.defaultButtonBackground
        }
    }
}

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
