//Handles UI state and business logic
import Foundation

// This enum defines the different types of buttons on calculator
// Each type has different colors and behaviors
enum ButtonType {
    case number(Int)
    case operation(Operation)
    case function(FunctionType)
    case decimal
}

enum FunctionType {
    case allClear       // AC
    case plusMinus      // +/-
    case percentage     // %
}
// This is the manager that connects our calculator brain to the UI
// It decides what to show on screen and how to respond to button taps

class CalculatorViewModel: ObservableObject {
    //ObservableObject makes your class "watchable" by the UI. When data in this class changes, SwiftUI automatically updates the screen.
    // @Published means SwiftUI will automatically update the screen when these change
    @Published var displayText: String = "0"        // What shows on the calculator screen
    @Published var currentOperation: Operation = .none   // Which operation button is highlighted
    @Published var operationDisplay: String = ""    // Shows operation in display like iPhone
    
    private var calculatorModel = CalculatorModel()     // Our calculator brain
    private var currentNumber: Double = 0               // The number being typed
    private var shouldResetDisplay = false              // True when we need to clear screen for new number
    private var isTypingNumber = false                  // True when user is actively typing a number
    private var pendingOperation: Operation = .none     // Operation waiting to be performed
    

    // This function gets called every time any calculator button is pressed
    // It decides what to do based on which type of button was tapped
    
    func buttonTapped(_ buttonType: ButtonType) {
        
        switch buttonType {
            
        case .number(let digit):
            // User tapped a number button (0-9)
            handleNumberInput(digit)
            
        case .operation(let operation):
            // User tapped an operation button (+, -, ×, ÷, =)
            handleOperationInput(operation)
            
        case .function(let functionType):
            // User tapped a function button (AC, +/-, %)
            handleFunctionInput(functionType)
            
        case .decimal:
            // User tapped the decimal point (.)
            handleDecimalInput()
        }
    }
    
    // Handles when user taps number buttons (0, 1, 2, etc.)
    
    private func handleNumberInput(_ digit: Int) {
        
        if shouldResetDisplay {
            // Start fresh display after operation or equals
            displayText = String(digit)
            shouldResetDisplay = false
            isTypingNumber = true
        } else if displayText == "0" || !isTypingNumber {
            // Replace the "0" or start new number
            displayText = String(digit)
            isTypingNumber = true
        } else {
            // Add digit to existing number (like typing "123")
            displayText += String(digit)
        }
        
        // Update our internal number tracking
        currentNumber = Double(displayText) ?? 0
    }
    
    // Handles operation buttons (+, -, ×, ÷, =)
    
    private func handleOperationInput(_ operation: Operation) {
        
        if operation == .equals {
            // Equals button pressed - calculate result
            if pendingOperation != .none {
                let result = calculatorModel.performOperation(operation: .equals, with: currentNumber)
                displayText = formatNumber(result)
                currentNumber = result
                
                // Clear operation display and reset state
                operationDisplay = ""
                pendingOperation = .none
                currentOperation = .none
                shouldResetDisplay = true
                isTypingNumber = false
            }
        } else {
            // Operation button pressed (+, -, ×, ÷)
            
            // If there's a pending operation and user typed a new number, calculate first
            if pendingOperation != .none && isTypingNumber {
                let result = calculatorModel.performOperation(operation: .equals, with: currentNumber)
                displayText = formatNumber(result)
                currentNumber = result
            }
            
            // Store current number and set up new operation
            let firstNumber = currentNumber
            pendingOperation = operation
            currentOperation = operation
            
            // Show operation in display
            operationDisplay = formatNumber(firstNumber) + " " + operationSymbol(operation)
            
            // Tell model about the operation
            _ = calculatorModel.performOperation(operation: operation, with: firstNumber)
            
            // Prepare for next number input
            shouldResetDisplay = true
            isTypingNumber = false
        }
    }
    
    // Returns the symbol for display
    private func operationSymbol(_ operation: Operation) -> String {
        switch operation {
        case .add: return "+"
        case .subtract: return "−"
        case .multiply: return "×"
        case .divide: return "÷"
        default: return ""
        }
    }
    
    // Handles function buttons (AC, +/-, %)
    
    private func handleFunctionInput(_ functionType: FunctionType) {
        switch functionType {
        case .allClear:
            // AC resets everything back to starting state
            calculatorModel.reset()
            displayText = "0"
            currentNumber = 0
            currentOperation = .none
            pendingOperation = .none
            operationDisplay = ""
            shouldResetDisplay = false
            isTypingNumber = false
            
        case .plusMinus:
            // Toggle positive/negative
            if currentNumber != 0 {
                currentNumber = -currentNumber
                displayText = formatNumber(currentNumber)
            }
            
        case .percentage:
            // Convert to percentage (divide by 100)
            currentNumber = currentNumber / 100
            displayText = formatNumber(currentNumber)
        }
    }
    
    // Handles decimal point button (.)
    
    private func handleDecimalInput() {
        
        if shouldResetDisplay {
            // Start new decimal number
            displayText = "0."
            shouldResetDisplay = false
            isTypingNumber = true
        } else if !displayText.contains(".") {
            // Add decimal point if there isn't one already
            displayText += "."
            isTypingNumber = true
        }
        
        // Update our number tracking
        currentNumber = Double(displayText) ?? 0
    }
    
    // Formats numbers to display nicely (removes unnecessary decimals)
    
    private func formatNumber(_ number: Double) -> String {
        
        // If it's a whole number, don't show decimal
        if number.truncatingRemainder(dividingBy: 1) == 0 {
            return String(format: "%.0f", number)
        } else {
            // Show decimal but remove trailing zeros
            return String(number)
        }
    }
    
    // This helps the UI know what buttons to create and how they should look
    
    func getCalculatorButtons() -> [[ButtonType]] {
        return [
            // Row 1: AC, +/-, %, ÷
            [.function(.allClear), .function(.plusMinus), .function(.percentage), .operation(.divide)],
            
            // Row 2: 7, 8, 9, ×
            [.number(7), .number(8), .number(9), .operation(.multiply)],
            
            // Row 3: 4, 5, 6, -
            [.number(4), .number(5), .number(6), .operation(.subtract)],
            
            // Row 4: 1, 2, 3, +
            [.number(1), .number(2), .number(3), .operation(.add)],
            
            // Row 5: 0, ., =
            [.number(0), .decimal, .operation(.equals)]
        ]
    }
}
