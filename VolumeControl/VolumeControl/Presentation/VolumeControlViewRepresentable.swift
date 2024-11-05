import SwiftUI

struct VolumeControlViewRepresentable {
    let volume: Double
    let barHeight: VolumeBarHeight
    let barSpacing: VolumeBarSpacing
    let activeColor: Color
    let inactiveColor: Color
    let bars: [BarRepresentable]
}

extension VolumeControlViewRepresentable {
    init(volume: Double, barHeight: VolumeBarHeight, barSpacing: VolumeBarSpacing, activeColorHex: String, inactiveColorHex: String, bars: [BarRepresentable]) {
        self.volume = volume
        self.barHeight = barHeight
        self.barSpacing = barSpacing
        self.activeColor = Color(hex: activeColorHex)
        self.inactiveColor = Color(hex: inactiveColorHex)
        self.bars = bars
    }
}
