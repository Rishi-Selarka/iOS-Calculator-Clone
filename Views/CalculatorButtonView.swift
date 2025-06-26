//Reusable button component
import SwiftUI

// This creates a single calculator button that looks and behaves like iPhone calculator
// It's reusable - we'll use this same component for ALL buttons (numbers, operations, functions)

struct CalculatorButtonView: View {
    
    let buttonType: ButtonType          // What kind of button this is (number, operation, etc.)
    let isSelected: Bool               // True when operation button should be highlighted (orange/white)
    let action: () -> Void             // What happens when button is tapped
    
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .font(buttonFont)
                .foregroundColor(textColor)
                .frame(width: buttonWidth, height: buttonHeight)
                .background(buttonBackgroundView)
                .clipShape(buttonShape)
        }
        .buttonStyle(PlainButtonStyle())    // Removes default button styling
    }
    
    // Glass effect background for number and decimal buttons
    @ViewBuilder
    private var buttonBackgroundView: some View {
        switch buttonType {
        case .number(_), .decimal:
            // Glass morphism effect
            ZStack {
                // Semi-transparent background
                Color.white.opacity(0.1)
                
                // Glass effect with blur and border
                RoundedRectangle(cornerRadius: buttonHeight / 2)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.white.opacity(0.25),
                                Color.white.opacity(0.05)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: buttonHeight / 2)
                            .stroke(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.white.opacity(0.5),
                                        Color.white.opacity(0.2)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 1
                            )
                    )
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: buttonHeight / 2))
            }
            
        default:
            // Regular background for operations and functions
            backgroundColor
        }
    }
    
    
    // What text shows on the button
    private var buttonText: String {
        switch buttonType {
        case .number(let digit):
            return String(digit)
            
        case .operation(let operation):
            switch operation {
            case .add:      return "+"
            case .subtract: return "−"      // Note: this is minus sign (−), not hyphen (-)
            case .multiply: return "×"      // Note: this is multiplication (×), not letter x
            case .divide:   return "÷"
            case .equals:   return "="
            case .none:     return ""
            }
            
        case .function(let functionType):
            switch functionType {
            case .allClear:     return "AC"
            case .plusMinus:    return "±"
            case .percentage:   return "%"
            }
            
        case .decimal:
            return "."
        }
    }
    
    // What font size to use
    private var buttonFont: Font {
        switch buttonType {
        case .number(_), .decimal:
            return .system(size: 35, weight: .regular)      // Numbers: regular weight
            
        case .operation(_):
            return .system(size: 35, weight: .regular)      // Operations: regular weight
            
        case .function(_):
            return .system(size: 30, weight: .regular)      // Functions: slightly smaller
        }
    }
    
    // What color the text should be
    private var textColor: Color {
        switch buttonType {
        case .number(_), .decimal:
            return .white                   // Numbers: white text
            
        case .operation(_):
            if isSelected {
                return .orange              // Selected operation: orange text on white background
            } else {
                return .white               // Normal operation: white text
            }
            
        case .function(_):
            return .black                   // Functions: black text
        }
    }
    
    // What color the button background should be
    private var backgroundColor: Color {
        switch buttonType {
        case .number(_), .decimal:
            return Color.clear                  // Transparent for glass effect
            
        case .operation(_):
            if isSelected {
                return .white                   // Selected operation: white background
            } else {
                return .orange                  // Normal operation: orange background
            }
            
        case .function(_):
            return Color(UIColor.lightGray)     // Functions: light gray
        }
    }
    
    // Button width (0 button is wider than others)
    private var buttonWidth: CGFloat {
        switch buttonType {
        case .number(0):
            return 180      // Zero button is double width (like iPhone)
        default:
            return 85       // All other buttons are normal width
        }
    }
    
    // Button height (all buttons same height)
    private var buttonHeight: CGFloat {
        return 85
    }
    
    // Button shape (rounded rectangle)
    private var buttonShape: some Shape {
        RoundedRectangle(cornerRadius: buttonHeight / 2)    // Makes perfectly rounded buttons
    }
}

