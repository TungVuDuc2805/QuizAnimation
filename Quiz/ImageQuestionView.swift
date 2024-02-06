//    
// ImageQuestionView.swift
// Quiz
// Created by Tung Vu Duc.
// Copyright © 2024. All rights reserved.
// 

import SwiftUI

struct ImageQuestionView: View {
    let image: String
    
    var body: some View {
        ZStack {
            Color.white
            
            Image(image)
                .resizable()
                .padding(30)
        }
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: Color.gray.opacity(0.3), radius: 5)
    }
}
