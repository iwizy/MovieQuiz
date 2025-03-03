//
//  MovieQuizViewController.swift
//  MovieQuiz
//
//  Главный контроллер


import UIKit


final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Private Properties
   

    
    var alertBox: AlertPresenter? // переменная алерта с опциональным типом АлертПрезентера
    private var statisticService: StatisticServiceProtocol?
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Округляем первую картинку
        imageView.layer.cornerRadius = 20
        presenter = MovieQuizPresenter(viewController: self)
        

        alertBox = AlertPresenter(viewController: self) // Инициализируем алерт
        statisticService = StatisticService()
    
        showLoadingIndicator()
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        presenter.yesButtonClicked()
        changeButtonState(isEnabled: false)
        tapticFeedback()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        presenter.noButtonClicked()
        changeButtonState(isEnabled: false)
        tapticFeedback()
    }
    
    // MARK: - Private Methods
    
    // Метод показа первого вопроса
    func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
        imageView.layer.borderWidth = 0
    }
    
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
            imageView.layer.masksToBounds = true
            imageView.layer.borderWidth = 8
            imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        }
    
    func resetBorder() {
        imageView.layer.borderWidth = 0
    }
    
  
    
    // метод показа индикатора загрузки
    func showLoadingIndicator() {
        activityIndicator.startAnimating() // включаем анимацию
    }
    
    // метод скрытия индикатора загрузки
    func hideLoadingIndicator() {
        activityIndicator.stopAnimating() // выключаем анимацию
    }
    
    // Метод включения / выключения кнопок
    func changeButtonState(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    // Метод виброотклика
    private func tapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
}
