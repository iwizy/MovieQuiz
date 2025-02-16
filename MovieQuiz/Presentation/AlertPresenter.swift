//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Класс Алерта

import UIKit

final class AlertPresenter {
    // Создаем опциональную переменную с типом UIViewController.
    private weak var viewController: UIViewController?
    
    // Инициализируем
    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
    
    func showAlert(model: AlertModel) {
        // создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: model.title, // заголовок всплывающего окна
            message: model.message, // текст во всплывающем окне
            preferredStyle: .alert
        ) // preferredStyle может быть .alert или .actionSheet
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            model.completion?()
        }
        alert.addAction(action)
        viewController?.present(alert, animated: true, completion: nil)
        
    }
    
}
