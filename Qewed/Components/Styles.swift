//
//  Styles.swift
//  Qewed
//
//  Created by Desmond Fitch on 2/3/22.
//

import SwiftUI

struct StrokeStyle: ViewModifier {
    var cornerRadius: CGFloat
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content.overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(
                    .linearGradient(
                        colors: [
                            .white.opacity(colorScheme == .dark ? 0.7 : 0.3),
                            .black.opacity(0.3)
                        ], startPoint: .top, endPoint: .bottom
                    )
                )
                .blendMode(.overlay)
        )
    }
}

extension View {
    func strokeStyle(cornerRadius: CGFloat = 30) -> some View {
        modifier(StrokeStyle(cornerRadius: cornerRadius))
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let screenSize = UIScreen.main.bounds.size
}

struct customTextField: View {
    var text: Binding<String>
    var entry: String
    
    var body: some View {
        TextField(entry, text: text)
    }
}

struct customSecureField: View {
    var text: Binding<String>
    var entry: String
    
    var body: some View {
        SecureField(entry, text: text)
            .padding(20)
            .font(.body.bold())
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .cornerRadius(15)
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
}
