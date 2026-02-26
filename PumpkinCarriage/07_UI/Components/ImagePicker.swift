import Foundation
import _PhotosUI_SwiftUI

@Observable
final class ImagePicker {

    var selectedItems: [PhotosPickerItem] = [] {
        didSet {
            loadImages()
        }
    }

    private(set) var imageDrafts: [ImageDraft] = []

    private var loadGeneration: UUID = UUID()
    private(set) var currentGeneration: UUID? = nil
    private(set) var finishedGeneration: UUID? = nil
    private var expectedCount: Int = 0
    private var completedCount: Int = 0

    func loadImages() {
            let generation = UUID()
            loadGeneration = generation
            currentGeneration = generation
            finishedGeneration = nil

            imageDrafts.removeAll()
            expectedCount = selectedItems.count
            completedCount = 0

            guard expectedCount > 0 else {
                currentGeneration = nil
                return
            }

            for (idx, item) in selectedItems.enumerated() {
                Task {
                    guard self.loadGeneration == generation else { return }

                    // Success = draft, fail = nil
                    let loadedDraft: ImageDraft? = await {
                        if let data = try? await item.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            return ImageDraft(sortOrder: idx, uiImage: image)
                        }
                        return nil
                    }()

                    await MainActor.run {
                        guard self.loadGeneration == generation else { return }

                        if let draft = loadedDraft {
                            self.imageDrafts.append(draft)
                            self.imageDrafts.sort { $0.sortOrder < $1.sortOrder }
                        }

                        self.completedCount += 1

                        if self.completedCount >= self.expectedCount {
                            self.finishedGeneration = generation
                        }
                    }
                }
            }
        }
    }


struct ImageDraft: Identifiable {
    var id: String = UUID().uuidString
    var sortOrder: Int
    var uiImage: UIImage
    var createdAt: Date = .now
    var status: DraftUploadStatus = .ready
    var caption: String?
}

extension ImageDraft: Equatable {
    static func == (lhs: ImageDraft, rhs: ImageDraft) -> Bool { lhs.id == rhs.id }
}

enum DraftUploadStatus: String {
    case ready
    case uploading
    case failed
}
