//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Alexander Agafonov on 02.03.2025.
//

import UIKit

final class MoviewQuizPresenter {
    
    private let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    
    // Метод конвертирования модели мок-вопроса во вью модель вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
}
