import Foundation

final class GetConfigurationRepositoryImpl: NSObject, GetConfigurationRepository, XMLParserDelegate, @unchecked Sendable {
    var volume: Double = 0.0
    var numberOfBars: Int = 0
    var activeColorHex: String = ""
    var inactiveColorHex: String = ""

    private let fileName: String
    private var currentElement = ""
    private var foundCharacters = ""

    init(fileName: String = "config") {
        self.fileName = fileName
    }

    func getConfiguration() -> Result<VolumeControlConfiguration, DomainError> {
        guard let path = Bundle.main.url(forResource: fileName, withExtension: "xml") else {
            return .failure(.xmlNotFound)
        }

        guard let parser = XMLParser(contentsOf: path) else {
            return .failure(.invalidXML)
        }

        parser.delegate = self
        if parser.parse() {
            let configuration = VolumeControlConfiguration(
                volume: volume,
                numberOfBars: numberOfBars,
                activeColorHex: activeColorHex,
                inactiveColorHex: inactiveColorHex
            )
            return .success(configuration)
        } else {
            return .failure(.xmlParseError)
        }
    }

    // MARK: - XMLParserDelegate Methods
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String] = [:]) {
        currentElement = elementName
        foundCharacters = ""
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        foundCharacters += string
    }

    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        switch elementName {
        case "Volume":
            volume = Double(foundCharacters) ?? 0.0
        case "NumberOfBars":
            numberOfBars = Int(foundCharacters) ?? 0
        case "ActiveColorHex":
            activeColorHex = foundCharacters
        case "InactiveColorHex":
            inactiveColorHex = foundCharacters
        default:
            break
        }
    }

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("Error parsing XML: \(parseError.localizedDescription)")
    }
}
