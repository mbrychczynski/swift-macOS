//
//  ContentView.swift
//  CowsAndBulls
//
//  Created by Mateusz Brychczynski on 21/05/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var guesses = [String]()
    @State private var guess = ""
    @State private var answer = ""
    @State private var isGameOver = false
    @State private var isReachedMax = false
    
    @AppStorage("maximumGuesses") private var maximumGuesses = 100
    @AppStorage("answerLength") private var answerLength = 4
    @AppStorage("enableHardMode") private var enableHardMode = false
    @AppStorage("showGuessCount") private var showGuessCount = false
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Enter a guess...", text: $guess)
                    .onSubmit(submitGuess)
                Button("Go", action:  submitGuess)
            }
            .padding()
            List(0..<guesses.count, id: \.self) { index in
                let guess = guesses[index]
                let shouldShowResult = (enableHardMode == false) || (enableHardMode && index == 0)
                
                HStack {
                    Text(guess)
                    Spacer()
                    if shouldShowResult {
                        Text(result(for: guess))
                    }
                }
            }
            .listStyle(.sidebar)
            if showGuessCount {
                Text("Guesses: \(guesses.count)/\(maximumGuesses)")
                    .padding()
            }
        }
        .frame(width: 250)
        .frame(minHeight: 300, maxHeight: .infinity)
        .onAppear(perform: startNewGame)
        .onChange(of: answerLength) { _ in startNewGame() }
        .onChange(of: maximumGuesses) { _ in startNewGame() }
        .alert("You win!", isPresented: $isGameOver) {
            Button("OK", action: startNewGame)
        } message: {
            if guesses.count < 10 {
                Text("Congratulations! You're score is \(guesses.count) Click OK to play again.")
            } else if guesses.count < 20 {
                Text("No too bad! You're score is \(guesses.count) Click OK to play again.")
            } else {
                Text("Mapet! You're score is \(guesses.count) Click OK to play again.")
            }
            
        }
        .alert("Game over", isPresented: $isReachedMax) {
            Button("OK", action: startNewGame)
        } message: {
            Text("You lost. You have reached the maximum number of attempts. The correct answer is: \(answer)")
        }
        .navigationTitle("Cows and Bulls")
        .touchBar {
            HStack {
                Text("Guesses: \(guesses.count)")
                    .touchBarItemPrincipal()
                Spacer(minLength: 200)
            }
        }
    }
    
    func submitGuess() {
        guard Set(guess).count == answerLength else { return }
        guard guess.count == answerLength else { return }
        
        let badCharacters = CharacterSet(charactersIn: "0123456789").inverted
        guard guess.rangeOfCharacter(from: badCharacters) == nil else { return }
        
        if guesses.contains(guess) { return }
        guesses.insert(guess, at: 0)
        
        if result(for: guess).contains("\(answerLength)b") {
            isGameOver = true
        }
        
        if guesses.count == maximumGuesses {
            isReachedMax = true
        }
        
        guess = ""
    }
    
    func result(for guess: String) -> String {
        var bulls = 0
        var cows = 0
        let guessLetters = Array(guess)
        let answerLetters = Array(answer)
        
        for (index, letter) in guessLetters.enumerated() {
            if letter == answerLetters[index] {
                bulls += 1
            } else if answerLetters.contains(letter) {
                cows += 1
            }
        }
        
        return "\(bulls)b \(cows)c"
    }
    
    func startNewGame() {
        guard answerLength >= 3 && answerLength <= 8 else { return }
        guess = ""
        guesses.removeAll()
        answer = ""
        
        let numbers = (0...9).shuffled()
        
        for i in 0..<answerLength {
            answer.append(String(numbers[i]))
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
