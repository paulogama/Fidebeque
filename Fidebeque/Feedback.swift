//
//  Feedback.swift
//  Fidebeque
//
//  Created by Paulo Gama on 16/06/17.
//  Copyright © 2017 Paulo Gama. All rights reserved.
//

import Foundation
import Firebase

struct Feedback {
 
    var content: String?
    
    init(content: String) {
        self.content = content
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String : Any] else { return nil }
        guard let content  = dict["content"]  as? String else { return nil }
        
        self.content = content
    }

    
}
