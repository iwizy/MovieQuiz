//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Alexander Agafonov on 02.02.2025.
//

import UIKit

protocol QuestionFactoryProtocol {
    func requestNextQuestion() -> QuizQuestion?
    // var image: UIImage? { get }
    // var text: String { get }
    // var correctAnswer: Bool { get }
}
