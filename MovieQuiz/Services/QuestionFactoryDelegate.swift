//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Делегат фабрики вопросов

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    // Метод, который вызывается когда вопрос получен
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer() // сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // сообщение об ошибке загрузки
    func didFailToLoadImage(with error: Error) // ошибка загрузки картинки
}
