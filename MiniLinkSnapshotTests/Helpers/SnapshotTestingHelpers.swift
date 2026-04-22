import SwiftUI
import SnapshotTesting

@MainActor
func assertVariantSnapshot<V: View>(
    _ view: V,
    layout: SwiftUISnapshotLayout,
    testName: String = #function
) {
    let sharedSnapshotFile: StaticString = #file

    assertSnapshot(
        of: view.environment(\.colorScheme, .light),
        as: .image(layout: layout),
        named: "Light",
        record: true,
        file: sharedSnapshotFile,
        testName: testName
    )
    assertSnapshot(
        of: view.environment(\.colorScheme, .dark),
        as: .image(layout: layout),
        named: "Dark",
        record: true,
        file: sharedSnapshotFile,
        testName: testName,
    )
}
