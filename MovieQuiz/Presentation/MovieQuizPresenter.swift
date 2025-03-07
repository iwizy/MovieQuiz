//
//  MovieQuizPresenter.swift.swift
//  MovieQuiz
//
//  Класс презентера

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    
    // MARK: - Public Properties
    
    var correctAnswers: Int = 0
    
    // MARK: - Private Properties
    
    private let questionsAmount: Int = 10 // константа с общим количеством вопросов
    private var currentQuestionIndex: Int = 0 // Стартовое значение индекса первого элемента массива вопросов
    
    private var currentQuestion: QuizQuestion? // переменная текущего вопроса с опциональным типом вопроса
    private var statisticService: StatisticServiceProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    // private weak var viewController: MovieQuizViewController?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    // MARK: - Initializers
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        questionFactory?.loadData()
        viewController.showLoadingIndicator()
    }
    
    // MARK: - Public Methods
    
    func didFailToLoadData(with error: any Error) {
        let model = AlertModel(title: "Ошибка", message: "Ошибка загрузки данных", buttonText: "Попробовать ещё раз")
        { [weak self] in
            guard let self else { return }
            self.questionFactory?.loadData()
        }
        
        self.viewController?.alertBox?.showAlert(model: model)
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswers = 0
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
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    // метода показа сообщения об ошибке
    func showNetworkError(message: String) {
        viewController?.hideLoadingIndicator() // скрываем индикатор загрузки
        
        // создайте и покажите алерт
        let model = AlertModel(title: "Ошибка", message: "Ошибка загрузки данных", buttonText: "Попробовать ещё раз")
        { [weak self] in
            guard let self else { return }
            self.restartGame()
            self.questionFactory?.loadData()
        }
        
        self.viewController?.alertBox?.showAlert(model: model)
        
    }
    
    // метод показа алерта в случае ошибки загрузки картинки
    func didFailToLoadImage(with error: Error) {
        let model = AlertModel(title: "Ошибка", message: "Ошибка загрузки изображения", buttonText: "Попробовать ещё раз")
        { [weak self] in
            guard let self else { return }
            self.questionFactory?.loadData()
        }
        
        self.viewController?.alertBox?.showAlert(model: model)
    }
    
    // Показ результата вопроса в виде рамки красного или зеленого цвета
    func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
            correctAnswers += 1
        } else {
            viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        }
        
        dispatcher()
    }
    
    // MARK: - Private Methods
    // Метод диспетчера
    private func dispatcher() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.showNextQuestionOrResults()
            viewController?.resetBorder()
            
            // Делаем рамку нулевой, чтобы не отображалась на следующем вопросе
            viewController?.changeButtonState(isEnabled: true)
        }
    }
    
    private func didAnswer(isYes: Bool) {
        guard let currentQuestion else { return }
        let giveAnswer = isYes
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
    }
    
    private func showNextQuestionOrResults() {
        if self.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: self.questionsAmount)
            let model = AlertModel(
                title: "Этот раунд окончен!",
                message: """
                         Ваш результат: \(correctAnswers)/\(questionsAmount)
                         Количество сыгранных квизов: \(statisticService.gamesCount)
                         Рекорд: \(statisticService.bestGame.correct)/\(statisticService.bestGame.total) (\(statisticService.bestGame.date.dateTimeString))
                         Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
                         """,
                buttonText: "Сыграть еще раз")
            { [weak self] in
                guard let self else { return }
                self.restartGame()
                self.questionFactory?.requestNextQuestion()
            }
            self.viewController?.alertBox?.showAlert(model: model)
            
        } else {
            self.switchToNextQuestion()
            didLoadDataFromServer()
        }
    }
}
