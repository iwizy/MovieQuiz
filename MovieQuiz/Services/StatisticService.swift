//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alexander Agafonov on 10.02.2025.
//

import Foundation

final class StatisticService: StatisticServiceProtocol {
    private let storage: UserDefaults = .standard
    
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: "gamesCount")
        }
        set {
            storage.set(newValue, forKey: "gamesCount")
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: "correctAnswers")
            let total = storage.integer(forKey: "totalQuestions")
            let date = storage.object(forKey: "date") as? Date ?? Date()
            let gameResult = GameResult(
                correct: correct,
                total: total,
                date: date)
        }
        set {
            storage.set(newValue, forKey: "correctAnswers")
            storage.set(newValue, forKey: "totalQuestions")
            storage.set(newValue, forKey: "date")
        }
    }
    
    var totalAccuracy: Double {
        var totalCorrectAnswers: Int = 0
        var totalGames = storage.integer(forKey: "gamesCount")
        var accuracy: Double = 0
        
        accuracy = (Double(totalCorrectAnswers) / (Double(totalGames) * 10)) * 100
        
        return accuracy
    }
    
    func store(correct count: Int, total amount: Int) {
        
    }
    
  
}
