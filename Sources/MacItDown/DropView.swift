import SwiftUI
import UniformTypeIdentifiers

struct DropView: View {

    let onFilesDropped: ([URL]) -> Void

    @State private var isTargeted = false

    var body: some View {

        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(isTargeted ? Color.accentColor.opacity(0.08) : Color.primary.opacity(0.03))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(
                        isTargeted ? Color.accentColor.opacity(0.6) : Color.primary.opacity(0.1),
                        style: StrokeStyle(lineWidth: 1.5, dash: isTargeted ? [] : [8, 6])
                    )
                    .animation(.spring(duration: 0.2), value: isTargeted)
            }
            .overlay {
                VStack(spacing: 14) {
                    Image(systemName: isTargeted ? "arrow.down.circle.fill" : "document.badge.arrow.down")
                        .font(.system(size: 32, weight: .light))
                        .foregroundStyle(isTargeted ? Color.accentColor : .secondary)
                        .symbolEffect(.bounce, value: isTargeted)

                    VStack(spacing: 5) {
                        Text(isTargeted ? "Release to convert" : "Drop a file here")
                            .font(.title3)
                            .fontWeight(.medium)

                        Text("PDF · Word · Excel · PowerPoint · and more")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .scaleEffect(isTargeted ? 1.015 : 1)
            .animation(.spring(duration: 0.2, bounce: 0.3), value: isTargeted)
            .onDrop(of: [UTType.fileURL.identifier], isTargeted: $isTargeted) { providers in
                handleDrop(providers: providers)
            }
    }

    private func handleDrop(providers: [NSItemProvider]) -> Bool {

        var urls: [URL] = []
        let group = DispatchGroup()

        for provider in providers {
            group.enter()
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, _ in
                defer { group.leave() }
                if let data = item as? Data,
                   let url = URL(dataRepresentation: data, relativeTo: nil) {
                    urls.append(url)
                }
            }
        }

        group.notify(queue: .main) {
            onFilesDropped(urls)
        }

        return true
    }
}
