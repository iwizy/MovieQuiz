//
//  StatisticService.swift
//  MovieQuiz
//
//  Класс статистики

import Foundation

final class StatisticService: StatisticServiceProtocol {
    
    // MARK: - Публичные свойства
    // Общее количество сыгранных игр
    var gamesCount: Int {
        get { storage.integer(forKey: Keys.gamesCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.gamesCount.rawValue) }
    }
    
    // Переменная лучшей игры с типом модели GameResult
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult( // переменная результата игры, на вход принимает модель и потом возвращает значение
                correct: correct,
                total: total,
                date: date)
        }
        set { // проверяем лучшая ли игра или нет
            let current = bestGame
            if newValue.bestGame(game: current) == true {
                storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
                storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
                storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
            }
        }
    }
    
    // Расчет средней точности
    var totalAccuracy: Double {
        if gamesCount == 0 { return 0 } // проверка счетчика игр для избежания деления на ноль
        let accuracy: Double = (Double(totalCorrectAnswers) / (Double(gamesCount) * 10)) * 100
        return accuracy
    }
    
    // MARK: - Приватные свойства
    // Создаем переменную для более простого обращения к хранилищу вместо UserDefault.standard...
    private let storage: UserDefaults = .standard
    
    // Перечисление для ключей доступа к storage
    private enum Keys: String {
        case totalCorrectAnswers
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalQuestionsCount
    }
    
    // Переменная с общим количеством заданных вопросов
    private var totalQuestionsCount: Int {
        get { storage.integer(forKey: Keys.totalQuestionsCount.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalQuestionsCount.rawValue) }
    }
    
    // Переменная с общим количеством правильных ответов
    private var totalCorrectAnswers: Int {
        get { storage.integer(forKey: Keys.totalCorrectAnswers.rawValue) }
        set { storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue) }
    }
    
    // MARK: - Публичные методы
    // Метод сохранения результатов
    func store(correct count: Int, total amount: Int) {
        let current = bestGame
        let newValue: GameResult = GameResult(
            correct: count,
            total: amount,
            date: Date())
        
        gamesCount += 1
        totalCorrectAnswers += count
        totalQuestionsCount += amount
        if newValue.bestGame(game: current) == true {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
        }
        
    }
    
}
