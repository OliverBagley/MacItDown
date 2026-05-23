import SwiftUI

struct MarkdownView: View {

    let markdown: String

    var body: some View {

        Text(.init(markdown))
            .textSelection(.enabled)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
