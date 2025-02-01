//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Alexander Agafonov on 02.02.2025.
//

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
}
