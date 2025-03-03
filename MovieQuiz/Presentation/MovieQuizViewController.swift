//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Главный контроллер


import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
    private var correctAnswers = 0 // Счетчик корректных вопросов
    private var questionFactory: QuestionFactoryProtocol? // переменная фабрики с опциональным типом протокола фабрики
    private var currentQuestion: QuizQuestion? // переменная текущего вопроса с опциональным типом вопроса
    private var alertBox: AlertPresenter? // переменная алерта с опциональным типом АлертПрезентера
    private var statisticService: StatisticServiceProtocol?
    private let presenter = MoviewQuizPresenter()
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Округляем первую картинку
        imageView.layer.cornerRadius = 20
        presenter.viewController = self
        
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self) // Инициализируем делегат
        questionFactory?.requestNextQuestion() // Вызываем метод фабрики вопросов для показа вопроса
        alertBox = AlertPresenter(viewController: self) // Инициализируем алерт
        statisticService = StatisticService()
        
        showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    // MARK: - Public Methods
    
    // метод на случай успешной загрузки
    func didLoadDataFromServer() {
        activityIndicator.stopAnimating() // скрываем индикатор загрузки
        questionFactory?.requestNextQuestion()
    }
    
    // метод в случае ошибки
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    // метод показа алерта в случае ошибки загрузки картинки
    func didFailToLoadImage(with error: Error) {
        let model = AlertModel(title: "Ошибка", message: "Ошибка загрузки изображения", buttonText: "Попробовать ещё раз")
        { [weak self] in
            guard let self else { return }
            self.questionFactory?.loadData()
        }
        
        alertBox?.showAlert(model: model)
    }
    
    // MARK: - QuestionFactoryDelegate
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = presenter.convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.currentQuestion = currentQuestion
        presenter.yesButtonClicked()
        //changeButtonState(isEnabled: false)
        //tapticFeedback()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        // распаковываем, прерываем, если вопроса нет
        guard let currentQuestion = currentQuestion else {
            return
        }
        let giveAnswer = false
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
        changeButtonState(isEnabled: false)
        
        // Вызов метода виброотклика
        tapticFeedback()
    }
    
    // MARK: - Private Methods
    
    // Метод показа первого вопроса
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderWidth = 0
    }
    
    // Метод показа результата
    private func show(quiz result: QuizResultsViewModel) {
        
        // Создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: result.buttonText, style: .default) { [weak self] _ in
            guard let self else { return }
            
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            
            questionFactory?.requestNextQuestion()
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
        self.imageView.layer.borderWidth = 0
    }
    
    // Метод диспетчера
    private func dispatcher() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            // Код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0 // Делаем рамку нулевой, чтобы не отображалась на следующем вопросе
            
            // Деактивируем кнопки для предотвращения повторных нажатий перед показом следующего вопроса
            self.changeButtonState(isEnabled: true)
        }
    }
    
    // Показ результата вопроса в виде рамки красного или зеленого цвета
    func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            correctAnswers += 1
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
        }
        imageView.layer.borderWidth = 8
        dispatcher()
    }
    
    // Метод для переключения вопросов или показа результата
    private func showNextQuestionOrResults() {
        if presenter.isLastQuestion() {
            statisticService?.store(correct: correctAnswers, total: presenter.questionsAmount)
            let model = AlertModel( // Создаем переменную model c типом AlertModel и инициализируем
                title: "Этот раунд окончен!",
                message: """
                         Ваш результат: \(correctAnswers)/\(presenter.questionsAmount)
                         Количество сыгранных квизов: \(statisticService?.gamesCount ?? 1)
                         Рекорд: \(statisticService?.bestGame.correct ?? correctAnswers)/\(statisticService?.bestGame.total ?? presenter.questionsAmount) (\(statisticService?.bestGame.date.dateTimeString ?? Date().dateTimeString))
                         Средняя точность: \(String(format: "%.2f", statisticService?.totalAccuracy ?? 0))%
                         """,
                buttonText: "Сыграть еще раз")
            { [weak self] in // Замыкание, где выполняем нужные действия
                guard let self else { return }
                self.presenter.resetQuestionIndex()
                self.correctAnswers = 0
                self.questionFactory?.requestNextQuestion()
            }
            alertBox?.showAlert(model: model) // Вызов алерта
        } else {
            presenter.switchToNextQuestion()
            // Идём в состояние "Вопрос показан"
            didLoadDataFromServer()
        }
    }
    
    // метода показа сообщения об ошибке
    private func showNetworkError(message: String) {
        hideLoadingIndicator() // скрываем индикатор загрузки
        
        // создайте и покажите алерт
        let model = AlertModel(title: "Ошибка", message: "Ошибка загрузки данных", buttonText: "Попробовать ещё раз")
        { [weak self] in
            guard let self else { return }
            self.presenter.resetQuestionIndex()
            self.correctAnswers = 0
            self.questionFactory?.loadData()
        }
        
        alertBox?.showAlert(model: model)
        
    }
    
    // метод показа индикатора загрузки
    private func showLoadingIndicator() {
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // метод скрытия индикатора загрузки
    private func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // выключаем анимацию
    }
    
    // Метод включения / выключения кнопок
    private func changeButtonState(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    // Метод виброотклика
    private func tapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
