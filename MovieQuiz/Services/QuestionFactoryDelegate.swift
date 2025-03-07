//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Делегат фабрики вопросов

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?) // Метод, который вызывается когда вопрос получен
    func didLoadDataFromServer() // Сообщение об успешной загрузке
    func didFailToLoadData(with error: Error) // Сообщение об ошибке загрузки
    func didFailToLoadImage(with error: Error) // Ошибка загрузки картинки
}
