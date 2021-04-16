//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Terry Thrasher on 2021-04-05.
//
//  Completed challenges from the project.

import SwiftUI

// Challenge 3 from project 3 asks me to create a FlagImage() view that renders one flag image using the specific modifiers we've applied to the flags.
struct FlagImage: View {
    var flag: String
    
    var body: some View {
        Image(flag)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    // Challenge 1 asked me to add a property to store the score, modify it when the user gets an answer correct, and display the score in the alert.
    @State private var score = 0
    // Challenge 3 asked me to add an alert message telling the user which flag they incorrectly chose.
    @State private var scoreMessage = ""
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                
                ForEach(0..<3) { number in
                    Button(action: {
                        self.flagTapped(number)
                    }) {
                        FlagImage(flag: "\(self.countries[number])")
                    }
                }
                
                // Challenge 2 asked me to show the player's current score in a label directly below the flags.
                VStack {
                    Text("Score: \(score)")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            scoreTitle = "Correct"
            scoreMessage = "You got it! That's \(countries[correctAnswer]) all right. Your score is \(score)."
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "Wrong! You tapped \(countries[number]). Your score is still \(score)."
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
