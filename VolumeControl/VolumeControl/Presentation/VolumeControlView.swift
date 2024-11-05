import SwiftUI

struct VolumeControlView: View {
    @Environment(VolumeControlViewModel.self)
    var viewModel
    let representable: VolumeControlViewRepresentable

    var body: some View {
        VStack {
            VStack(spacing: representable.barSpacing.rawValue) {
                ForEach(representable.bars) { bar in
                    Rectangle()
                        .fill(bar.color)
                        .frame(height: representable.barHeight.rawValue)
                }
            }
            Text("Volume is set to \(Int(representable.volume))%")
        }
        .padding(.horizontal)
        .gesture(
            DragGesture(minimumDistance: .zero)
                .onChanged { value in
                    viewModel.onDragged(yPoint: value.location.y)
                }
        )
        .sensoryFeedback(.selection, trigger: representable.volume)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.onConfigurationButtonTapped()
                } label: {
                    Image(systemName: "gear")
                }

            }
        }
        .onGeometryChange(for: CGFloat.self) { geometry in
            geometry.frame(in: .local).height
        } action: { newValue in
            viewModel.onHeightUpdated(newValue)
        }
        .sheet(
            isPresented: Binding(
            get: { viewModel.showConfiguration },
            set: { _ in viewModel.onConfigurationButtonTapped() }
        )
        ) {
            VolumeControlConfigurationView(representable: representable)
                .presentationDetents([.medium])
        }
    }
}
