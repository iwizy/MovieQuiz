import UIKit


final class MovieQuizViewController: UIViewController {
    
    // MARK: - IB Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet weak var noButton: UIButton!
    @IBOutlet weak var yesButton: UIButton!
    
    // MARK: - Private Properties
    
    private var currentQuestionIndex = 0 // Стартовое значение индекса первого элемента массива вопросов
    private var correctAnswers = 0 // Счетчик корректных вопросов
    
    // Массив моковых вопросов
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    // Структура вопроса
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    // Структура вью модели одного вопроса
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    // Структура вью модели результата
    struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    // MARK: - Overrides Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Округляем первую картинку
        imageView.layer.cornerRadius = 20
        
        // Вызываем функцию показа, на вход даем модель через функцию конвертирования на входе которой даем первый элемент массива с вопросами
        show(quiz: convert(model: questions[0]))
    }
    
    
    // MARK: - IB Actions
    
    @IBAction private func yesButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == true)
        yesButton.isEnabled = false
        
        // Вызов метода виброотклика
        tapticFeedback()
    }
    
    @IBAction private func noButtonClicked(_ sender: Any) {
        showAnswerResult(isCorrect: questions[currentQuestionIndex].correctAnswer == false)
        noButton.isEnabled = false
        
        // Вызов метода виброотклика
        tapticFeedback()
    }
    
    
    // MARK: - Private Methods
    
    // Метод конвертирования модели мок-вопроса во вью модель вопроса
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
        return questionStep
    }
    
    // Метод показа первого вопроса
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 8
    }
    
    // Метод показа результата
    private func show(quiz result: QuizResultsViewModel) {
        // Создаём объекты всплывающего окна
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let action = UIAlertAction(title: result.buttonText, style: .default) {  _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(quiz: viewModel)
            self.imageView.layer.borderWidth = 0
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Метод диспетчера
    private func dispatcher() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Код, который мы хотим вызвать через 1 секунду
            self.showNextQuestionOrResults()
            self.imageView.layer.borderWidth = 0 // Делаем рамку нулевой, чтобы не отображалась на следующем вопросе
            
            // Деактивируем кнопки для предотвращения повторных нажатий перед показом следующего вопроса
            self.yesButton.isEnabled = true
            self.noButton.isEnabled = true
        }
    }
    
    // Показ результата вопроса в виде рамки красного или зеленого цвета
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            imageView.layer.borderColor = UIColor.ypGreen.cgColor
            imageView.layer.borderWidth = 8
            correctAnswers += 1
            dispatcher()
        } else {
            imageView.layer.borderColor = UIColor.ypRed.cgColor
            imageView.layer.borderWidth = 8
            dispatcher()
        }
    }
    
    // Метод для переключения вопросов или показа результата
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            
            show(quiz: QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(correctAnswers)/\(questions.count)",
                buttonText: "Сыграть еще раз"))
            
        } else {
            currentQuestionIndex += 1
            // Идём в состояние "Вопрос показан"
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
    
    // Метод виброотклика
    private func tapticFeedback() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
}
