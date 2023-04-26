//
//  ContentView.swift
//  Calculator
//
//  Created by Jagtar Singh matharu on 2023-03-15.
//

import SwiftUI
import AVFoundation
struct ContentView: View {
    
      @State private var currentNumber = ""
      @State private var storedNumber = ""
      @State private var storedOperation = ""
      @State private var showingError = false
      @State private var errorMessage = ""
      @State private var currentImage=""
      var screenWidth = UIScreen.main.bounds.size.width
      var screenHeight = UIScreen.main.bounds.size.height
      let buttons = [
          
          ["+", "_", "Divide", "C"],
          ["1", "2", "3", "mod"],
          ["4", "5", "6", "Multiply"],
          ["7", "8", "9", "="],
          ["0"]
      ]
    
    var body: some View { 
        VStack() {
              
            ZStack
               {
                   Image("screen")
                       .resizable()
                       .aspectRatio(contentMode: .fit)
                   Text(currentNumber)
                }
               .frame(width: screenWidth/1.3,height: screenHeight/7)
            Spacer()

            VStack(spacing:0) {
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing:0)
                    {
                        ForEach(row, id: \.self)
                        { tag in
                            
                            Button(
                                action: {
                                    buttonPressed(tag)
                                    AudioServicesPlaySystemSound(1103)
                                },
                                label:{
                                    Image(tag)
                                        .resizable()
                                }
                            )
                            
                        }
                    }
                    .frame(width: screenWidth/1.3,height: screenHeight/7.5)
                }
                
            }
            
           }
           .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
           .background(Color.black)
           .alert(isPresented: $showingError) {
               Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
           }
          
        
        
        
       }
    func buttonPressed(_ label: String) {
            switch label {
            case "+", "_", "Multiply", "Divide","mod":
                if storedOperation != "" {
                    performCalculation()
                }
                storedNumber = currentNumber
                storedOperation = label
                currentNumber = ""
            case "=":
                performCalculation()
                storedOperation = ""
            case "C":
                currentNumber = ""
                storedNumber = "0"
                storedOperation=""
                
            case ".":
                if currentNumber.contains(".") {
                    showingError = true
                    errorMessage = "Number already contains a decimal point"
                    return
                }
                fallthrough
            default:
                currentNumber += label
            }
        }
    
    
    func performCalculation() {
        guard let num1 = Double(storedNumber),
              let num2 = Double(currentNumber)
        else {
            showingError = true
            errorMessage = "Invalid calculation"
            return
        }
        switch storedOperation {
        case "+":
            currentNumber = "\(num1 + num2)"
        case "_":
            currentNumber = "\(num1 - num2)"
        case "Multiply":
            currentNumber = "\(num1 * num2)"
            
        case "mod":
            currentNumber = "\(Int(num1) % Int(num2))"
            
        case "Divide":
            if num2 == 0 {
                showingError = true
                errorMessage = "Cannot divide by zero"
                return
            }
            currentNumber = "\(num1 / num2)"
        default:
            break
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
