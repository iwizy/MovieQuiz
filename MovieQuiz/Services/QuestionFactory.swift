//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Класс фабрики вопросов

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    // MARK: - Публичные свойства
    //Создание переменной delegate c опциональным типом QuestionFactoryDelegate
    weak var delegate: QuestionFactoryDelegate?
    
    
    // MARK: - Приватные свойства
    private let moviesLoader: MoviesLoading
    private var movies: [MostPopularMovie] = []
    
    // MARK: - Иниты
    // Инициализация делегата и загрузчика фильмов
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    // MARK: - Публичные методы
    //Метод запроса следующего вопроса
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
                DispatchQueue.main.async { [weak self] in // Кидаем в основной поток, так как интерфейс
                    guard let self else { return }
                    self.delegate?.didFailToLoadImage(with: error) // Уведомляем делегат об ошибке
                }
                return
            }
            
            let rating = Float(movie.rating) ?? 0
            
            let text = "Рейтинг этого фильма больше чем 7?"
            let correctAnswer = rating > 7
            
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
    
    // Метод загрузки данных
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items // Сохраняем фильм в нашу новую переменную
                    self.delegate?.didLoadDataFromServer() // Сообщаем, что данные загрузились
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error) // Сообщаем об ошибке
                }
            }
        }
    }
}
