//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Протокол фабрики

import Foundation

protocol QuestionFactoryProtocol {
    func requestNextQuestion() // Метод запроса следующего вопроса
    func loadData() // метод загрузки данных
}
