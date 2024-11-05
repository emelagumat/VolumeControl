import SwiftUI

@main
struct VolumeControlApp: App {
    @State var volumeControlViewModel = VolumeControlViewModel()

    var body: some Scene {
        WindowGroup {
            VolumeControlScreen()
                .environment(volumeControlViewModel)
        }
    }
}
