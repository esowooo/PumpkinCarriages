






import Foundation
import SwiftUI

struct TitleStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.custom("Rockwell-Regular", size: 40))
    }
}

extension View {
    func primaryTitleStyle() -> some View {
        self.modifier(TitleStyle())
    }
}

struct SecondaryTitleStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Rockwell-Regular", size: 16))
    }
}

extension View {
    func secondaryTitleStyle() -> some View {
        self.modifier(SecondaryTitleStyle())
    }
}

struct MenuTitleStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 20, weight: .semibold))
    }
}

extension View {
    func menuTitleStyle() -> some View {
        self.modifier(MenuTitleStyle())
    }
}


struct PrimaryTextStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
    }
}

extension View {
    func primaryTextStyle() -> some View {
        self.modifier(PrimaryTextStyle())
    }
}


struct SecondaryTextStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .regular))
    }
}

extension View {
    func secondaryTextStyle() -> some View {
        self.modifier(SecondaryTextStyle())
    }
}

struct LogoTextStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.system(size: 12, weight: .thin))
    }
}

extension View {
    func logoTextStyle() -> some View {
        self.modifier(LogoTextStyle())
    }
}



struct CaptionTextStyle: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .font(.caption)
            .foregroundStyle(.main.opacity(0.4))
    }
}

extension View {
    func captionTextStyle() -> some View {
        self.modifier(CaptionTextStyle())
    }
}


