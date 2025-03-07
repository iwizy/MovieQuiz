//
//  StatisticServiceProtocol.swift
//  MovieQuiz
//
//  Протокол сервиса статистики

import Foundation

protocol StatisticServiceProtocol {
    var gamesCount: Int { get } // Счетчик игр
    var bestGame: GameResult { get } // Результат лучшей игры
    var totalAccuracy: Double { get } // Средняя точность ответов
    
    func store(correct count: Int, total amount: Int) // Метод сохранения результатов
}
