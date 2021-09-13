//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Mariana Yamamoto on 8/17/21.
//

import SwiftUI

struct FlagImage: View {
    var imgName: String
    var body: some View {
        Image(self.imgName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct ContentView: View {
    @State private var score = 0
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)

    @State private var animationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea(.all)

            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }

                ForEach(0 ..< 3 ) { number in
                    Button(action: {
                            withAnimation(.easeInOut) {
                        if self.flagTapped(number) {
                            animationAmount += 360
                            opacityAmount = 0.25
                        } else {
                            animationAmount = 0
                        }
                        }}) {
                        FlagImage(imgName: self.countries[number])
                    }
                    .rotation3DEffect(.degrees(number == correctAnswer ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                    .opacity(number != correctAnswer ? opacityAmount : 1)
                }

                Text("Total score: \(score)")
                    .foregroundColor(.white)
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle), message: Text(scoreMessage), dismissButton: .default(Text("Continue")) {
                self.askQuestion()
            })
        }
    }

    func flagTapped(_ number: Int) -> Bool {
        if number == correctAnswer {
            scoreTitle = "Correct"
            score += 5
            scoreMessage = "Your score is \(score)."
        } else {
            scoreTitle = "Wrong"
            score = score == 0 ? 0 : score - 1
            scoreMessage = "That's the flag of \(countries[number])! Your score is \(score)."
        }
        showingScore = true
        return number == correctAnswer
    }

    func askQuestion() {
        countries = countries.shuffled()
        correctAnswer = Int.random(in: 0...2)
        opacityAmount = 1
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
