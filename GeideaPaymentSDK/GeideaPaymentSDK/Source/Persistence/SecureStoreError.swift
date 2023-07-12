//
//  SecureStoreError.swift
//  GeideaPaymentSDK
//
//  Created by euvid on 15/10/2020.
//

import Foundation

public struct SecureStoreErrorConstants {
    static let CREDENTIALS_STORE_ERROR = "Failed to store credentials"
    static let CREDENTIALS_RETREIVE_ERROR = "Failed to get credentials"
}

public enum SecureStoreError: Error {
  case string2DataConversionError
  case data2StringConversionError
  case unhandledError(message: String)
}

extension SecureStoreError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .string2DataConversionError:
      return NSLocalizedString("String to Data conversion error", comment: "")
    case .data2StringConversionError:
      return NSLocalizedString("Data to String conversion error", comment: "")
    case .unhandledError(let message):
      return NSLocalizedString(message, comment: "")
    }
  }
}
