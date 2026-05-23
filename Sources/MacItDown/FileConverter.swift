import Foundation

enum ConversionError: LocalizedError {

    case conversionFailed(String)
    case bundledPythonMissing

    var errorDescription: String? {

        switch self {

        case .conversionFailed(let message):
            return message

        case .bundledPythonMissing:
            return "Bundled Python environment not found"
        }
    }
}

struct FileConverter {

    static func convert(url: URL) throws -> String {

        guard let resourcePath = Bundle.main.resourcePath else {

            throw ConversionError.bundledPythonMissing
        }

        let pythonPath = "\(resourcePath)/python-env/bin/python"

        if !FileManager.default.fileExists(atPath: pythonPath) {

            throw ConversionError.bundledPythonMissing
        }

        let process = Process()

        process.executableURL = URL(fileURLWithPath: pythonPath)

        process.arguments = [
            "-m",
            "MacItDown",
            url.path
        ]

        let outputPipe = Pipe()
        let errorPipe = Pipe()

        process.standardOutput = outputPipe
        process.standardError = errorPipe

        try process.run()

        process.waitUntilExit()

        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
        let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()

        let outputText = String(
            data: outputData,
            encoding: .utf8
        ) ?? ""

        let errorText = String(
            data: errorData,
            encoding: .utf8
        ) ?? ""

        if process.terminationStatus != 0 {

            throw ConversionError.conversionFailed(errorText)
        }

        return outputText
    }
}
