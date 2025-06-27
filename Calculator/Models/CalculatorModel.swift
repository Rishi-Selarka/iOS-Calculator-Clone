// The brain of computer logic
import Foundation

// Creating an enum that defines all math operations of the calculator

enum Operation {
    
    case add
    case subtract
    case multiply
    case divide
    case equals
    case none // When no operation is selected
    
}

// This is the pure logic part - it only does math calculations
// No UI, no display logic, just pure math like a real calculator chip

struct CalculatorModel {
    // These store the calculator's "memory" during calculations
    private var accumulator: Double = 0.0 // stores the running total
    private var pendingOperation: Operation = .none // Remembers which operation (+, -, etc) we're doing
    private var operand: Double = 0.0 // stores the second number in calculator
    
    // This function does the actual math when you press =
    // It takes two numbers and an operation, returns the result
    
    mutating func performOperation(operation: Operation, with number: Double) -> Double {
        
        switch operation {
        case .add:
            accumulator = number
            pendingOperation = .add
            return accumulator
            
        case .subtract:
            accumulator = number
            pendingOperation = .subtract
            return accumulator
            
        case .multiply:
            accumulator = number
            pendingOperation = .multiply
            return accumulator
            
        case .divide:
            accumulator = number
            pendingOperation = .divide
            return accumulator
            
        case .equals:
            // Now we actually do the math with both numbers
            let result = calculateResult(firstNumber: accumulator, secondNumber: number , operation: pendingOperation)
            
            // Reset everything for next calculation
            accumulator = result
            pendingOperation = .none
            operand = 0.0
            
            return result
            
        case .none:
            // No operation selected, just return the number as-is
            return number
            
            
        }
        
    }
    // This is where the actual math happens
    // It's private because only our model should use it
    
    private func calculateResult(firstNumber: Double, secondNumber: Double, operation: Operation) -> Double {
        
        switch operation {
        case .add:
            return firstNumber + secondNumber
            
        case .subtract:
            return firstNumber - secondNumber
            
        case .multiply:
            return firstNumber * secondNumber
            
        case .divide:
            if secondNumber == 0 {
                return 0
            }
            return firstNumber / secondNumber
        
        default:
            // If no operation, just return the second number
            return secondNumber
            
        }
    }
    // Helper function to reset calculator (for AC button)
    mutating func reset() {
        accumulator = 0.0
        pendingOperation = .none
        operand = 0.0
    }
}
