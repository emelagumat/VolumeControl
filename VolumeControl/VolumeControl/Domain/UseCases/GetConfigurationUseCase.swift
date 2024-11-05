protocol GetConfigurationRepository {
    func getConfiguration() -> Result<VolumeControlConfiguration, DomainError>
}

final class GetConfigurationUseCase {
    private let repository: any GetConfigurationRepository

    init(repository: any GetConfigurationRepository) {
        self.repository = repository
    }

    func getConfiguration() -> Result<VolumeControlConfiguration, DomainError> {
        repository.getConfiguration()
    }
}
