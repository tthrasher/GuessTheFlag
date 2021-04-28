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

    @State private var spinDegrees = 0.0
    @State private var opacityForIncorrectFlags = 1.0
    
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
                
                // Challenge 1 from project 6 asks me to make the correct answer flag spin 360° on the Y axis when tapped. I've made it so that the correct flag spins whenever any flag is tapped.
                ForEach(0..<3) { number in
                    Button(action: {
                        withAnimation {
                            self.flagTapped(number)
                            spinDegrees += 360
                        }
                    }) {
                        FlagImage(flag: "\(self.countries[number])")
                    }
                    .rotation3DEffect(.degrees(number == correctAnswer ? spinDegrees : 0), axis: (x: 0.0, y: 1.0, z: 0.0))
                    // Challenge 2 from project 6 asks me to make the other two flags fade out to 25% opacity when the correct flag is tapped.
                    .opacity(number == correctAnswer ? 1.0 : opacityForIncorrectFlags)
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
            opacityForIncorrectFlags = 0.25
        } else {
            scoreTitle = "Wrong"
            scoreMessage = "Wrong! You tapped \(countries[number]). Your score is still \(score)."
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        opacityForIncorrectFlags = 1.0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
