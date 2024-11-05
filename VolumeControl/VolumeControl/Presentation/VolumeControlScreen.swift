import SwiftUI

struct VolumeControlScreen: View {
    @Environment(VolumeControlViewModel.self)
    var viewModel

    var body: some View {
        NavigationStack {
            switch viewModel.state {
            case .loading:
                ProgressView()
            case .loaded(let representable):
                VolumeControlView(representable: representable)
            case .error(let errorText):
                Text(errorText)
            }
        }
        .task { viewModel.onLoad() }
    }
}

#Preview {
    VolumeControlScreen()
        .environment(VolumeControlViewModel())
}
