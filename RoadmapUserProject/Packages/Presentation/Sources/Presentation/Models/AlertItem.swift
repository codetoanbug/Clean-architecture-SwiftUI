//
//  AlertItem.swift
//  Presentation
//
//  Created by Prank on 18/9/25.
//

import Foundation

public struct AlertItem: Identifiable {
    public let id = UUID()
    public let title: String
    public let message: String
    public let dismissButton: String
    
    public init(
        title: String = "Error",
        message: String,
        dismissButton: String = "OK"
    ) {
        self.title = title
        self.message = message
        self.dismissButton = dismissButton
    }
}
