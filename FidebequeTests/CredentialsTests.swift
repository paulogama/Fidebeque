//
//  CredentialsTests.swift
//  Fidebeque
//
//  Created by Paulo Gama on 09/06/17.
//  Copyright © 2017 Paulo Gama. All rights reserved.
//

import XCTest
@testable import Fidebeque

class CredentialsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testEmail() {
        let credentials = Credentials(email: "teste@teste.com", password: "12345678")
        XCTAssertEqual("teste@teste.com", credentials.email, "Wrong e-mail")
    }
    
    func testPassword() {
        let credentials = Credentials(email: "test@tw.com", password: "senha")
        XCTAssertEqual("senha", credentials.password, "Wrong password")
    }
    
}
