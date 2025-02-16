//
//  GameResult.swift
//  MovieQuiz
//
// Модель результатов игры

import Foundation

struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func bestGame(game: GameResult) -> Bool {
       correct > game.correct
    }
}
