//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Created by Alexander Agafonov on 02.03.2025.
//

import UIKit

final class MoviewQuizPresenter {
    
    let questionsAmount: Int = 10 // константа с общим количеством вопросов
    private var currentQuestionIndex: Int = 0 // Стартовое значение индекса первого элемента массива вопросов
    var currentQuestion: QuizQuestion? // переменная текущего вопроса с опциональным типом вопроса
    
    weak var viewController: MovieQuizViewController?
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    // Метод конвертирования модели мок-вопроса во вью модель вопроса
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let giveAnswer = isYes
        viewController?.showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
}
