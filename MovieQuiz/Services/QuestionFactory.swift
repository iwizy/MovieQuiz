//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Класс фабрики вопросов

import Foundation

class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Создание переменной delegate c опциональным типом QuestionFactoryDelegate
    weak var delegate: QuestionFactoryDelegate?
    
    // MARK: - Массив моковых вопросов
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
    
    // MARK: - Инициализация делегата
    init(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    
    // MARK: - Метод запроса следующего вопроса
    func requestNextQuestion() {
        
        // Распаковка. Говорим, что индекс у нас в диапазоне от 0 до количества вопросов, применяем метод выбора случайного элемента
        guard let index = (0..<questions.count).randomElement() else {
            
            // обращаемся опционально к делегату и к его методу, если вопросы не получены - прерываем
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        // Получаем индекс вопроса
        let question = questions[safe: index]
        
        // Вызываем делегат и передаем туда вопрос, если он был получен
        delegate?.didReceiveNextQuestion(question: question)
    }
    
    
    
} // завершающая скобка класса
