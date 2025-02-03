import UIKit


final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    // MARK: - IB Outlets
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    // MARK: - Private Properties
    private var currentQuestionIndex = 0 // Стартовое значение индекса первого элемента массива вопросов
    private var correctAnswers = 0 // Счетчик корректных вопросов
    private let questionsAmount: Int = 10 // константа с общим количеством вопросов
    private var questionFactory: QuestionFactoryProtocol? // переменная фабрики с опциональным типом протокола фабрики
    private var currentQuestion: QuizQuestion? // переменная текущего вопроса с опциональным типом вопроса
    
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Округляем первую картинку
        imageView.layer.cornerRadius = 20
        
        // Инициализируем делегат
        questionFactory = QuestionFactory(delegate: self)
        
        // Вызываем метод фабрики вопросов для показа вопроса
        questionFactory?.requestNextQuestion()
    }
    
    // MARK: - QuestionFactoryDelegate
    //
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else {
            return
        }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        // распаковываем, прерываем, если вопроса нет
        guard let currentQuestion = currentQuestion else {
            return
        }
        
        let giveAnswer = true
        showAnswerResult(isCorrect: giveAnswer == currentQuestion.correctAnswer)
        changeButtonState(isEnabled: false)
        
        // Вызов метода виброотклика
        tapticFeedback()
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
    
    // Метод конвертирования модели мок-вопроса во вью модель вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        return questionStep
    }
    
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
            guard let self = self else { return }
            
            self.currentQuestionIndex = 0
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
            guard let self = self else { return }
            
            // Код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0 // Делаем рамку нулевой, чтобы не отображалась на следующем вопросе
            
            // Деактивируем кнопки для предотвращения повторных нажатий перед показом следующего вопроса
            self.changeButtonState(isEnabled: true)
        }
    }
    
    // Показ результата вопроса в виде рамки красного или зеленого цвета
    private func showAnswerResult(isCorrect: Bool) {
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
        if currentQuestionIndex == questionsAmount - 1 {
            show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questionsAmount)",
                buttonText: "Сыграть еще раз"))
            
        } else {
            currentQuestionIndex += 1
            // Идём в состояние "Вопрос показан"
            self.questionFactory?.requestNextQuestion()
        }
    }
    
    // Метод включения/выключения кнопок
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
