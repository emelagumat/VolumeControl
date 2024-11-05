enum VolumeControlViewState {
    case loading
    case loaded(VolumeControlViewRepresentable)
    case error(String)
}
