//
//  GeideaPaymentSDKTests.swift
//  GeideaPaymentSDKTests
//
//  Created by euvid on 16/10/2020.
//

import XCTest
@testable import GeideaPaymentSDK

class GeideaPaymentSDKTests: XCTestCase {
    var secureStoreWithGenericPwd: SecureStore!

    override func setUpWithError() throws {
        let genericPwdQueryable =
            GenericPasswordQueryable(service: "PaymentSDKService")
          secureStoreWithGenericPwd =
            SecureStore(secureStoreQueryable: genericPwdQueryable)
          
    }

    override func tearDownWithError() throws {
        try? secureStoreWithGenericPwd.removeAllValues()
        super.tearDown()
    }

    func testSaveGenericPassword() {
      do {
        try secureStoreWithGenericPwd.setValue("TEST_1234567890", for: "genericPassword")
      } catch (let e) {
        XCTFail("Saving generic password failed with \(e.localizedDescription).")
      }
    }

    // 2
    func testReadGenericPassword() {
      do {
        try secureStoreWithGenericPwd.setValue("TEST_1234567890", for: "genericPassword")
        let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
        XCTAssertEqual("TEST_1234567890", password)
      } catch (let e) {
        XCTFail("Reading generic password failed with \(e.localizedDescription).")
      }
    }

    // 3
    func testUpdateGenericPassword() {
      do {
        try secureStoreWithGenericPwd.setValue("TEST_1234567890", for: "genericPassword")
        try secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword")
        let password = try secureStoreWithGenericPwd.getValue(for: "genericPassword")
        XCTAssertEqual("pwd_1235", password)
      } catch (let e) {
        XCTFail("Updating generic password failed with \(e.localizedDescription).")
      }
    }

    // 4
    func testRemoveGenericPassword() {
      do {
        try secureStoreWithGenericPwd.setValue("TEST_1234567890", for: "genericPassword")
        try secureStoreWithGenericPwd.removeValue(for: "genericPassword")
        XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword"))
      } catch (let e) {
        XCTFail("Saving generic password failed with \(e.localizedDescription).")
      }
    }


    // 5
    func testRemoveAllGenericPasswords() {
      do {
        try secureStoreWithGenericPwd.setValue("TEST_1234567890", for: "genericPassword")
        try secureStoreWithGenericPwd.setValue("pwd_1235", for: "genericPassword2")
        try secureStoreWithGenericPwd.removeAllValues()
        XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword"))
        XCTAssertNil(try secureStoreWithGenericPwd.getValue(for: "genericPassword2"))
      } catch (let e) {
        XCTFail("Removing generic passwords failed with \(e.localizedDescription).")
      }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
