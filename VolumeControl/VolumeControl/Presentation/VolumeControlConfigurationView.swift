import SwiftUI

struct VolumeControlConfigurationView: View {
    @Environment(VolumeControlViewModel.self) var viewModel
    @State var numberOfBarsInSlider: Double = 0
    @State var activeColorInPicker: Color = .clear
    @State var inactiveColorInPicker: Color = .clear

    let representable: VolumeControlViewRepresentable

    var body: some View {
        VStack(alignment: .leading, spacing: .zero) {
            volumeSlider
            Text("Bars \(Int(numberOfBarsInSlider))")
                .font(.footnote)
            Slider(
                value: $numberOfBarsInSlider,
                in: Double.minNumberOfBars...Double.maxVolume,
                onEditingChanged: { editing in
                    if !editing {
                        viewModel.onNumberOfBarsChanged(Int(numberOfBarsInSlider))
                    }
                }
            )
            activeColorPicker
            inactiveColorPicker
        }
        .padding()
        .onAppear {
            numberOfBarsInSlider = Double(representable.bars.count)
            activeColorInPicker = representable.activeColor
            inactiveColorInPicker = representable.inactiveColor
        }
        .onChange(of: activeColorInPicker) { _, newValue in
            if let colorHex = newValue.toHex() {
                viewModel.onActiveColorChanged(colorHex)
            }
        }
        .onChange(of: inactiveColorInPicker) { _, newValue in
            if let colorHex = newValue.toHex() {
                viewModel.onInactiveColorChanged(colorHex)
            }
        }
    }

    @ViewBuilder private var volumeSlider: some View {
        Text("Volume \(Int(representable.volume))")
            .font(.footnote)
        Slider(
            value: Binding(
                get: { representable.volume },
                set: { viewModel.onVolumeChanged($0) }
            ),
            in: Double.zero...Double.maxVolume,
            step: .maxVolume / Double(representable.bars.count)
        )
    }

    @ViewBuilder private var barsSlider: some View {
        Text("Bars \(Int(numberOfBarsInSlider))")
            .font(.footnote)
        Slider(
            value: $numberOfBarsInSlider,
            in: Double.minNumberOfBars...Double.maxVolume,
            onEditingChanged: { editing in
                if !editing {
                    viewModel.onNumberOfBarsChanged(Int(numberOfBarsInSlider))
                }
            }
        )
    }

    @ViewBuilder private var activeColorPicker: some View {
        ColorPicker(selection: $activeColorInPicker) {
            Text("Active color")
        }
        .padding(.vertical)
    }

    @ViewBuilder private var inactiveColorPicker: some View {
        ColorPicker(selection: $inactiveColorInPicker) {
            Text("Inactive color")
        }
        .padding(.vertical)
    }
}
