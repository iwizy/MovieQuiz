//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Делегат фабрики вопросов

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    // Метод, который вызывается когда вопрос получен
    func didReceiveNextQuestion(question: QuizQuestion?)
}
