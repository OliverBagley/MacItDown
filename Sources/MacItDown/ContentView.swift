import SwiftUI
import AppKit
import UniformTypeIdentifiers

struct ContentView: View {

    @AppStorage("selectedTheme")
    private var selectedTheme = AppTheme.system.rawValue

    @State private var markdownText = ""
    @State private var isProcessing = false
    @State private var showRawMarkdown = false
    @State private var statusText = "Drop a document to begin"
    @State private var currentFileName = ""

    private var currentTheme: AppTheme {
        AppTheme(rawValue: selectedTheme) ?? .system
    }

    var body: some View {

        VStack(spacing: 0) {

            topBar

            if markdownText.isEmpty {
                dropZone
            } else {
                Divider()
                markdownArea
                    .layoutPriority(1)
            }

            Divider()
            footerView
        }
        .frame(
            minWidth: markdownText.isEmpty ? 520 : 820,
            minHeight: markdownText.isEmpty ? 420 : 600
        )
        .animation(.spring(duration: 0.35, bounce: 0.1), value: markdownText.isEmpty)
        .overlay {
            if isProcessing {
                processingOverlay
                    .transition(.opacity.combined(with: .scale(scale: 0.97)))
            }
        }
        .animation(.spring(duration: 0.25), value: isProcessing)
    }
}

// MARK: - Top Bar

extension ContentView {

    var topBar: some View {

        HStack(spacing: 0) {

            // App identity
            HStack(spacing: 12) {
                Image(nsImage: NSApplication.shared.applicationIconImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 2) {
                    Text("MacItDown")
                        .font(.headline)
                    Text(statusText)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .animation(.default, value: statusText)
                }
            }

            Spacer()

            // Actions
            HStack(spacing: 8) {
                Button {
                    openFile()
                } label: {
                    Label("Open", systemImage: "folder")
                }
                .buttonStyle(.bordered)

                if !markdownText.isEmpty {
                    Button {
                        withAnimation(.spring(duration: 0.3, bounce: 0.1)) {
                            markdownText = ""
                            currentFileName = ""
                            statusText = "Drop a document to begin"
                        }
                    } label: {
                        Label("New", systemImage: "plus.circle")
                    }
                    .buttonStyle(.borderedProminent)
                    .transition(.asymmetric(
                        insertion: .scale.combined(with: .opacity),
                        removal: .opacity
                    ))
                }
            }
            .animation(.spring(duration: 0.25), value: markdownText.isEmpty)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
        .padding(.bottom, 16)
        .background(.ultraThinMaterial)
        .ignoresSafeArea(.all, edges: .top)
    }
}

// MARK: - Drop Zone

extension ContentView {

    var dropZone: some View {

        VStack {
            DropView { urls in
                Task { await processFiles(urls) }
            }
            .frame(height: 210)
            .padding(40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.97)),
            removal: .opacity.combined(with: .scale(scale: 0.97))
        ))
    }
}

// MARK: - Markdown Area

extension ContentView {

    var markdownArea: some View {

        VStack(spacing: 0) {

            // Toolbar
            HStack {
                Spacer()
                HStack(spacing: 8) {
                    Button {
                        withAnimation(.spring(duration: 0.25)) {
                            showRawMarkdown.toggle()
                        }
                    } label: {
                        Label(
                            showRawMarkdown ? "Preview" : "Source",
                            systemImage: showRawMarkdown ? "text.document" : "curlybraces"
                        )
                    }

                    Button { copyMarkdown() } label: {
                        Label("Copy", systemImage: "doc.on.doc")
                    }

                    Button { saveMarkdown() } label: {
                        Label("Save", systemImage: "square.and.arrow.down")
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.regular)
            }
            .padding(.horizontal, 28)
            .padding(.top, 20)
            .padding(.bottom, 8)

            ScrollView {
                Group {
                    if showRawMarkdown {
                        rawMarkdownView
                    } else {
                        renderedMarkdownView
                    }
                }
                .padding(28)
                .frame(maxWidth: .infinity)
                .animation(.spring(duration: 0.25), value: showRawMarkdown)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .transition(.asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.98)),
            removal: .opacity.combined(with: .scale(scale: 0.98))
        ))
    }

    var renderedMarkdownView: some View {

        MarkdownView(markdown: markdownText)
            .padding(40)
            .frame(maxWidth: 960, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.background.opacity(0.7))
                    .overlay {
                        RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .strokeBorder(.quaternary, lineWidth: 1)
                    }
            }
            .shadow(color: .black.opacity(0.06), radius: 16, y: 6)
    }

    var rawMarkdownView: some View {

        ScrollView(.horizontal) {
            Text(markdownText)
                .font(.system(size: 13, design: .monospaced))
                .textSelection(.enabled)
                .padding(36)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: 960)
        .background {
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(nsColor: .textBackgroundColor))
                .overlay {
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(.quaternary, lineWidth: 1)
                }
        }
        .environment(\.colorScheme, .dark)
    }
}

// MARK: - Processing Overlay

extension ContentView {

    var processingOverlay: some View {

        ZStack {
            Rectangle()
                .fill(.ultraThinMaterial)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ProgressView()
                    .scaleEffect(1.3)
                    .controlSize(.large)

                VStack(spacing: 6) {
                    Text("Converting")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text(currentFileName)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .truncationMode(.middle)
                        .frame(maxWidth: 280)
                }
            }
            .padding(.horizontal, 40)
            .padding(.vertical, 36)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
            .shadow(color: .black.opacity(0.12), radius: 30, y: 12)
        }
    }
}

// MARK: - Footer

extension ContentView {

    var footerView: some View {

        HStack {
            Button {
                cycleTheme()
            } label: {
                Image(systemName: currentTheme.icon)
                    .id(currentTheme.icon)
                    .frame(width: 22, height: 22)
                    .animation(.default, value: currentTheme.icon)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.secondary)
            .help("Toggle appearance (\(currentTheme.title))")

            Spacer()

            Text("MacItDown · 2026 · [oliverbagley.com](https://www.oliverbagley.com) · Based on [MarkItDown](https://github.com/microsoft/markitdown) © Microsoft")
                .font(.caption2)
                .foregroundStyle(.tertiary)

            Spacer()

            Color.clear.frame(width: 22, height: 22)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 7)
        .background(.ultraThinMaterial)
    }
}

// MARK: - Actions

extension ContentView {

    private func cycleTheme() {
        let all = AppTheme.allCases
        guard let idx = all.firstIndex(of: currentTheme) else { return }
        let next = all[(idx + 1) % all.count]
        selectedTheme = next.rawValue
        next.applyToApp()
    }

    private func openFile() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.allowedContentTypes = [
            .pdf, .spreadsheet, .presentation,
            UTType(filenameExtension: "docx") ?? .data,
            UTType(filenameExtension: "xlsx") ?? .data,
            UTType(filenameExtension: "pptx") ?? .data,
            .html, .xml, .json, .plainText, .rtf,
            UTType(filenameExtension: "csv") ?? .commaSeparatedText
        ]
        if panel.runModal() == .OK, let url = panel.url {
            Task { await processFiles([url]) }
        }
    }

    func processFiles(_ urls: [URL]) async {

        guard let url = urls.first else { return }

        await MainActor.run {
            currentFileName = url.lastPathComponent
            statusText = "Converting \(url.lastPathComponent)…"
            withAnimation(.spring(duration: 0.25)) {
                isProcessing = true
            }
        }

        do {
            let markdown = try await Task.detached(priority: .userInitiated) {
                try FileConverter.convert(url: url)
            }.value

            await MainActor.run {
                withAnimation(.spring(duration: 0.3, bounce: 0.05)) {
                    markdownText = markdown
                    isProcessing = false
                }
                statusText = url.lastPathComponent
            }

        } catch {
            await MainActor.run {
                withAnimation(.spring(duration: 0.25)) {
                    isProcessing = false
                }
                statusText = error.localizedDescription
            }
        }
    }

    private func copyMarkdown() {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(markdownText, forType: .string)
        statusText = "Copied to clipboard"
    }

    private func saveMarkdown() {
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "md") ?? .plainText]
        panel.nameFieldStringValue = currentFileName.isEmpty
            ? "document.md"
            : (URL(fileURLWithPath: currentFileName).deletingPathExtension().lastPathComponent + ".md")

        if panel.runModal() == .OK, let url = panel.url {
            do {
                try markdownText.write(to: url, atomically: true, encoding: .utf8)
                statusText = "Saved \(url.lastPathComponent)"
            } catch {
                statusText = "Save failed: \(error.localizedDescription)"
            }
        }
    }
}
