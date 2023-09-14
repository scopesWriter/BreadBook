//
//  ErrorViewType.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation

enum ErrorViewType {
    case technicalError
    case connectionError
    case noConnectionWithoutDrugs
    case noError
    
    var title: String {
        switch self {
        case .technicalError:
            return "Something went wrong."
        case .connectionError:
            return "No connection, don’t panic!"
        case .noConnectionWithoutDrugs:
            return "Internet Connection unstable."
        case .noError : return ""
        }
    }
    
    var subtitle: String {
        switch self {
        case .technicalError:
            return "Reload the page to view the content and continue using the app."
        case .connectionError:
            return "We’ve got you covered. Access a drugs index anywhere without internet access."
        case .noConnectionWithoutDrugs:
            return "Check your internet connection to continue using the app."
        case .noError : return ""
        }
    }
    
    var image: String {
        switch self {
        case .technicalError:
            return Icon.technicalError.rawValue
        case .connectionError, .noConnectionWithoutDrugs:
            return Icon.connectionError.rawValue
        case .noError : return ""
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .technicalError:
            return "Reload"
        case .connectionError, .noConnectionWithoutDrugs:
            return "Retry"
        case .noError : return ""
        }
    }
}
