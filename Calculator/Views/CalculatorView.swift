//Main calculator UI
import SwiftUI

// This creates the complete calculator that looks exactly like iPhone calculator
// It arranges all buttons in a grid and connects them to the ViewModel

struct CalculatorView: View {
    
    @StateObject private var viewModel = CalculatorViewModel()    // Our calculator brain manager
    
    var body: some View {
        VStack(spacing: 0) {
            
            // The top section that shows numbers and results
            VStack(spacing: 8) {
                Spacer()    // Push display content to bottom of display area
                
                // Operation display (like iPhone calculator)
                if !viewModel.operationDisplay.isEmpty {
                    HStack {
                        Spacer()    // Push text to right side (like iPhone)
                        
                        Text(viewModel.operationDisplay)
                            .font(.system(size: 30, weight: .regular))    // Smaller font for operation
                            .foregroundColor(.white.opacity(0.6))         // Dimmed color
                            .lineLimit(1)
                    }
                    .padding(.horizontal, 20)
                }
                
                // Main display (current number/result)
                HStack {
                    Spacer()    // Push text to right side (like iPhone)
                    
                    Text(viewModel.displayText)
                        .font(.system(size: 80, weight: .light))    // Large, thin font like iPhone
                        .foregroundColor(.white)
                        .lineLimit(1)                               // Keep on one line
                        .minimumScaleFactor(0.5)                   // Shrink text if too long
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
            .frame(height: 200)                    // Reduced height for display area
            .background(Color.black)               // Black background like iPhone
            
            // The button area arranged in rows
            VStack(spacing: 12) {                  // Spacing between rows
                
                // Row 1: AC, +/-, %, ÷
                HStack(spacing: 12) {              // Spacing between buttons in row
                    
                    CalculatorButtonView(
                        buttonType: .function(.allClear),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.function(.allClear))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .function(.plusMinus),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.function(.plusMinus))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .function(.percentage),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.function(.percentage))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .operation(.divide),
                        isSelected: viewModel.currentOperation == .divide
                    ) {
                        viewModel.buttonTapped(.operation(.divide))
                    }
                }
                
                // Row 2: 7, 8, 9, ×
                HStack(spacing: 12) {
                    
                    CalculatorButtonView(
                        buttonType: .number(7),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(7))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .number(8),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(8))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .number(9),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(9))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .operation(.multiply),
                        isSelected: viewModel.currentOperation == .multiply
                    ) {
                        viewModel.buttonTapped(.operation(.multiply))
                    }
                }
                
                // Row 3: 4, 5, 6, -
                HStack(spacing: 12) {
                    
                    CalculatorButtonView(
                        buttonType: .number(4),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(4))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .number(5),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(5))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .number(6),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(6))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .operation(.subtract),
                        isSelected: viewModel.currentOperation == .subtract
                    ) {
                        viewModel.buttonTapped(.operation(.subtract))
                    }
                }
                
                // Row 4: 1, 2, 3, +
                HStack(spacing: 12) {
                    
                    CalculatorButtonView(
                        buttonType: .number(1),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(1))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .number(2),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(2))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .number(3),
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(3))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .operation(.add),
                        isSelected: viewModel.currentOperation == .add
                    ) {
                        viewModel.buttonTapped(.operation(.add))
                    }
                }
                
                // Row 5: 0, ., =
                HStack(spacing: 12) {
                    
                    CalculatorButtonView(
                        buttonType: .number(0),     // This will be double-width automatically
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.number(0))
                    }
                    
                    CalculatorButtonView(
                        buttonType: .decimal,
                        isSelected: false
                    ) {
                        viewModel.buttonTapped(.decimal)
                    }
                    
                    CalculatorButtonView(
                        buttonType: .operation(.equals),
                        isSelected: false           // Equals button never stays highlighted
                    ) {
                        viewModel.buttonTapped(.operation(.equals))
                    }
                }
            }
            .padding(.horizontal, 20)              // Padding around entire button grid
            .padding(.bottom, 0)                   // No bottom padding - touch the bottom
            .background(Color.black)               // Black background like iPhone
        }
        .background(Color.black)                   // Entire calculator background
        .ignoresSafeArea(.all)                     // Fill entire screen including bottom
    }
}
