//
//  Event.swift
//  Fidebeque
//
//  Created by Paulo Gama on 12/06/17.
//  Copyright © 2017 Paulo Gama. All rights reserved.
//

import Foundation
import Firebase

class Event {
    
    var uid: String
    var title: String?
    var date: Date?
    var startHour: Date?
    var endHour: Date?
    
    init(uid: String, title: String, date: Date, startHour: Date, endHour: Date) {
        self.uid = uid
        self.title = title
        self.date = date
        self.startHour = startHour
        self.endHour = endHour
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        let uid  = snapshot.key 
        guard let title  = dict["title"] else { return nil }
        guard let date = dict["date"] else { return nil }
        guard let startHour = dict["startHour"] else { return nil }
        guard let endHour = dict["endHour"] else { return nil }
        
        self.uid = uid
        self.title = title
        self.date = date.toDate(dateFormat: "dd/MM/yy")
        self.startHour = startHour.toDate(dateFormat: "HH:mm")
        self.endHour = endHour.toDate(dateFormat: "HH:mm")
    }
    
}

extension Date {
    
    func toString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        return dateFormatter.string(from: self)
    }

}

extension String {
    
    func toDate(dateFormat format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self) ?? Date()
    }
    
}
