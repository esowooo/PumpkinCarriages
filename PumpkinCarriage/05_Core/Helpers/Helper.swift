






import Foundation
import SwiftUI


//MARK: - Utility
func openURL(_ string: String) {
    guard let url = URL(string: string) else { return }
    UIApplication.shared.open(url)
}


func copyToClipboard(_ text: String) {
    UIPasteboard.general.string = text
}


//MARK: - Keyboard

