//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Alexander Agafonov on 04.03.2025.
//

import Foundation


protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func highlightImageBorder(isCorrectAnswer: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func resetBorder()
    func changeButtonState(isEnabled: Bool)
    var alertBox: AlertPresenter? { get set }
}
