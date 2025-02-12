//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alexander Agafonov on 10.02.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
   
    
    private enum Keys: String {
        case totalCorrectAnswers
        case gamesCount
        case bestGameCorrect
        case bestGameTotal
        case bestGameDate
        case totalQuestionsCount
    }
    
    private var totalQuestionsCount: Int {
        get {
            return storage.integer(forKey: Keys.totalQuestionsCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalQuestionsCount.rawValue)
        }
    }
    
    private var totalCorrectAnswers: Int {
        get {
            return storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.totalCorrectAnswers.rawValue)
        }
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            let gameResult = GameResult(
                correct: correct,
                total: total,
                date: date)
            return gameResult
        }
        set {
            let current = bestGame
            if newValue.bestGame(game: current) == true {
                storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
                storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
                storage.set(newValue.date, forKey: Keys.bestGameDate.rawValue)
            }
        }
    }
    
    var totalAccuracy: Double {
        let accuracy: Double = (Double(totalCorrectAnswers) / (Double(gamesCount) * 10)) * 100
        return accuracy
    }
    
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
