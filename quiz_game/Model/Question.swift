//
//  Question.swift
//  quiz_game
//
//  Created by Vladi Khagay on 13/05/2022.
//

import Foundation


struct QuestionsList : Codable {
    var questions : [Question]?
}

struct Question: Codable {
    var type: String?
    var difficulty: String?
    var question: String?
    var correct_answer: String?
    var incorrect_answers: [String]
    var imageUrl:String?
}
