import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(Game_Controller_UITests.allTests),
    ]
}
#endif
