import SwiftUI
import UniformTypeIdentifiers

extension UTType {
  static var markdown: UTType {
    UTType(importedAs: "net.daringfireball.markdown")
  }
}

struct MarkdownDocument: FileDocument {
  var raw: String
  var html: String
  
  static var readableContentTypes: [UTType] { [.markdown, .plainText] }
  
  init(configuration: ReadConfiguration) throws {
    guard let data = configuration.file.regularFileContents,
          let raw = String(data: data, encoding: .utf8)
    else {
      throw CocoaError(.fileReadCorruptFile)
    }
    
    self.raw = raw
    self.html = MarkdownParser.parse(raw)
  }
  
  func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
    return configuration.existingFile!
  }
}
