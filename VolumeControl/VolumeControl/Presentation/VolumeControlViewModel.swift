import Foundation
import Observation

@Observable @MainActor final class VolumeControlViewModel {
    private let getConfigurationUseCase: GetConfigurationUseCase
    private var configuration: VolumeControlConfiguration?
    private var height: CGFloat = .zero

    private(set) var state: VolumeControlViewState = .loading
    private(set) var showConfiguration = false

    init(getConfigurationUseCase: GetConfigurationUseCase = .init(repository: GetConfigurationRepositoryImpl())) {
        self.getConfigurationUseCase = getConfigurationUseCase
        self.configuration = configuration
    }

    func onLoad() {
        let configurationResult = getConfigurationUseCase.getConfiguration()

        switch configurationResult {
        case .success(let configuration):
            self.configuration = configuration
            updateBars()
        case .failure(let error):
            state = .error(error.localizedDescription)
        }
    }

    func onDragged(yPoint: Double) {
        guard let numberOfBars = configuration?.numberOfBars else { return }
        let locationY = min(max(yPoint, .zero), height)

        let rawVolume = ((1 - locationY / height) * .maxVolume).rounded()
        let step = .maxVolume / Double(numberOfBars)

        let roundedVolume = round(rawVolume / step) * step
        updateConfiguration(\.volume, to: roundedVolume)
    }

    func onNumberOfBarsChanged(_ numberOfBars: Int) {
        updateConfiguration(\.numberOfBars, to: numberOfBars)
    }

    func onVolumeChanged(_ volume: Double) {
        updateConfiguration(\.volume, to: volume)
    }

    func onActiveColorChanged(_ colorHex: String) {
        updateConfiguration(\.activeColorHex, to: colorHex)
    }

    func onInactiveColorChanged(_ colorHex: String) {
        updateConfiguration(\.inactiveColorHex, to: colorHex)
    }

    func onConfigurationButtonTapped() {
        showConfiguration.toggle()
    }

    func onHeightUpdated(_ height: CGFloat) {
        self.height = height
    }
}

// MARK: - Private methods
private extension VolumeControlViewModel {
    func updateConfiguration<T>(_ keyPath: WritableKeyPath<VolumeControlConfiguration, T>, to newValue: T) {
        guard var configuration else { return }
        configuration[keyPath: keyPath] = newValue
        self.configuration = configuration
        updateBars()
    }

    func updateBars() {
        guard let configuration else { return }
        let height = barHeight(forConfiguration: configuration)
        let spacing = spacing(forHeight: height)

        state = .loaded(
            VolumeControlViewRepresentable(
                volume: configuration.volume,
                barHeight: height,
                barSpacing: spacing,
                activeColorHex: configuration.activeColorHex,
                inactiveColorHex: configuration.inactiveColorHex,
                bars: makeBars(
                    volume: configuration.volume,
                    numberOfBars: configuration.numberOfBars,
                    activeColorHex: configuration.activeColorHex,
                    inactiveColorHex: configuration.inactiveColorHex
                )
            )
        )
    }

    func makeBars(volume: Double, numberOfBars: Int, activeColorHex: String, inactiveColorHex: String) -> [BarRepresentable] {
        let step = .maxVolume / Double(numberOfBars)

        return (1...numberOfBars).reversed().map { index in
            let currentValue = Double(index) * step
            let isSelected = currentValue < volume + step / 2
            return BarRepresentable(index: index, colorHex: isSelected ? activeColorHex : inactiveColorHex)
        }
    }

    func spacing(forHeight barHeight: VolumeBarHeight) -> VolumeBarSpacing {
        switch barHeight {
        case .regular: .regular
        case .medium: .medium
        case .small, .extraSmall: .small
        }
    }

    func barHeight(forConfiguration configuration: VolumeControlConfiguration) -> VolumeBarHeight {
        switch configuration.numberOfBars {
        case ...20: .regular
        case 21...35: .medium
        case 36...50: .small
        default: .extraSmall
        }
    }
}
