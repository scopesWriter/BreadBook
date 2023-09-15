//
//  AccentColorSetter.swift
//  BreadBook
//
//  Created by Bishoy Badea [Pharma] on 14/09/2023.
//

import Foundation
import SwiftUI
import PhotosUI

class AccentColorSetter {
    static func setAccentColor() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(Color.mintGreen)
        UIView.appearance(whenContainedInInstancesOf: [UIImagePickerController.self]).tintColor = UIColor(Color.mintGreen)
        UIView.appearance(whenContainedInInstancesOf: [PHPickerViewController.self]).tintColor = UIColor(Color.mintGreen)
    }
}
