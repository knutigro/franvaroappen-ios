//
//  MessageHelper.swift
//  FranvaroAppen
//
//  Created by Knut Inge Grosland on 2016-11-09.
//  Copyright © 2016 Knut Inge Grosland. All rights reserved.
//

import Foundation


class MessageHelper {
    
    static let PhoneNumber = "0769446000"
    
    static func messageForInformation(personalNumber: String, message: String) -> String {
        assert(!personalNumber.isEmpty)
        assert(!message.isEmpty)

        return "Info " + personalNumber + " " + message
    }
    
    static func messageForSickLeave(personalNumber: String, from: Date?, to: Date?) -> String {
        assert(!personalNumber.isEmpty)
        
        if let from = from, let to = to {
            return "Frv " + personalNumber + " " + formatted(time: from) + "-" + formatted(time: to)
        } else {
            return "Frv " + personalNumber
        }
    }
    
    static func messageForAbsence(personalNumber: String, from: Date, to: Date?) -> String {
        assert(!personalNumber.isEmpty)
        
        guard let to = to else {
            return "Ledig " + personalNumber + " " + formatted(date: from)
        }
        
        if from.compare(to) == .orderedSame {
            return "Ledig " + personalNumber + " " + formatted(date: from)
        }
        
        if from.compare(to) == .orderedDescending {
            assertionFailure()
        }
        
        if (days(from: from, to: to) > 0) {
            return "Ledig " + personalNumber + " " + formatted(date: from) + "-" + formatted(date: to)
        } else {
            return "Ledig " + personalNumber + " " + formatted(date: from) + " " + formatted(time: from) + "-" + formatted(time: to)
        }
    }
    
    private static func formatted(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hhmm"
        
        return dateFormatter.string(from: time)
    }
    
    private static func formatted(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyMMdd"
        
        return dateFormatter.string(from: date)
    }
    
    private static func days(from: Date, to: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: from, to: to).day ?? 0
    }
}
