import SwiftUI

struct BarRepresentable: Identifiable {
    var id: Int { index }
    var index: Int
    let color: Color
}

extension BarRepresentable {
    init(index: Int, colorHex: String) {
        self.index = index
        self.color = Color(hex: colorHex)
    }
}
