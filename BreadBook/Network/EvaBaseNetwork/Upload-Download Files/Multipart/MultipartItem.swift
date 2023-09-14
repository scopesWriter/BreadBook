//
//  MultipartItem.swift
//  
//
//  Created by Gamal Mostafa on 31/01/2022.
//

import Foundation

public protocol MultipartItem{}

public class MultipartFormItem: MultipartItem {
    var name: String
    var value: String
    
    public init(name: String, value:String){
        self.name = name
        self.value = value
    }
}



public class MultipartDataItem: MultipartItem {
    var fieldName: String
    var fileName: String
    var mimeType: String
    var fileData: Data
    
    public init(fieldName: String, fileName: String, mimeType: String, fileData: Data) {
        self.fieldName = fieldName
        self.fileName = fileName
        self.mimeType = mimeType
        self.fileData = fileData
    }
    
}
