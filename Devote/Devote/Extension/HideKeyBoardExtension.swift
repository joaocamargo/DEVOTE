//
//  HideKeyBoardExtension.swift
//  Devote
//
//  Created by joao camargo on 11/08/21.
//

import Foundation
import SwiftUI


#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
