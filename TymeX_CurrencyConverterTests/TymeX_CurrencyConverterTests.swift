import Testing
import XCTest
@testable import TymeX_CurrencyConverter


class CurrencyConverterViewTests: XCTestCase {
    
    var viewModel: CurrencyConverterViewModel!
    
    // Set up View before testing
    override func setUp() {
        super.setUp()
        viewModel = CurrencyConverterViewModel()
    }
    
    // Clean up instance after each test
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    // Test input validation
    func testValidAmountInput() {
        let validAmount = "1000.00"
        viewModel.validateAmount(validAmount)
        XCTAssertFalse(viewModel.showAlert, "The alert should not be shown for valid input")
    }
    
    // Test wrong input handler
    func testNegativeAmountInput() {
        // Test with a negative amount
        let negativeAmount = "-1000"
        viewModel.validateAmount(negativeAmount)
        XCTAssertTrue(viewModel.showAlert, "The alert should be shown for negative input")
        XCTAssertEqual(viewModel.alertMessage, "Please enter a positive amount.")
    }

    // Test zero amount provided
    func testZeroAmountInput() {
        let zeroAmount = "0.00"
        viewModel.validateAmount(zeroAmount)
        XCTAssertTrue(viewModel.showAlert, "The alert should be shown for zero input")
        XCTAssertEqual(viewModel.alertMessage, "Please enter a positive amount.", "Alert message should be about positive amount")
    }

    // Test non-numeric input
    func testInvalidStringInput() {
        let invalidInput = "abc"
        viewModel.validateAmount(invalidInput)
        XCTAssertTrue(viewModel.showAlert, "The alert should be shown for invalid input")
        XCTAssertEqual(viewModel.alertMessage, "Invalid input. Please enter a valid number.", "Alert message should indicate invalid input")
    }
}

