//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Alexander Agafonov on 10.02.2025.
//

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func compareGames(game: GameResult) -> Bool {
       correct > game.correct
    }
}
