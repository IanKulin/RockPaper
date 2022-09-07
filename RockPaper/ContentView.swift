//
//  ContentView.swift
//  RockPaper
//
//  Created by Ian Bailey on 4/9/2022.
//

import SwiftUI


struct ContentView: View {
    @State var score = 0
    @State var goalIsWinThisTurn = Bool.random()
    @State var userSelection = 0
    @State var computerSelection = 0
    @State var winText = ""


    // game has two modes - revealResult - buttons don't work, and we can see the computer result
    // or not readyToPlay - user can chose their play
    @State var revealResult = false
    
    let rock = 0
    let paper = 1
    let scissors = 2
    let rpsEmoji = ["🪨", "📃", "✂️"]
    
        
    var body: some View {
        ZStack{
            LinearGradient(colors: [.white, .gray], startPoint: .top, endPoint: .bottom)
            VStack{
                Button("Score: \(score)"){
                    score = 0
                }
                .font(.title)
                .foregroundColor(.primary)
                
                Spacer()
                if goalIsWinThisTurn {
                    Text("Try to win")
                        .font(.title)
                }
                else {
                    Text("Try to lose")
                        .font(.title)
                }
                
                Spacer()
                HStack{
                    Spacer()
                    Button(rpsEmoji[rock]) {
                        processButton(selection: rock)
                    }
                    Spacer()
                    Button(rpsEmoji[paper]) {
                        processButton(selection: paper)
                    }
                    Spacer()
                    Button(rpsEmoji[scissors]){
                        processButton(selection: scissors)
                    }
                    Spacer()
                }.font(.system(size: 60))
                
                Spacer()
                if revealResult {
                    Text(rpsEmoji[computerSelection])
                        .font(.system(size: 200))
                    Text(winText).font(.title)
                    Spacer()
                    Button("Play again") {
                        goalIsWinThisTurn = Bool.random()
                        revealResult = false
                    }
                    .buttonStyle(CustomButtonStyle())
                }
                else {
                    Text(rpsEmoji[computerSelection])
                        .font(.system(size: 200))
                        .hidden()
                    Text(winText)
                        .font(.title)
                        .hidden()
                    Spacer()
                    Button("Play again") {
                        goalIsWinThisTurn = Bool.random()
                        revealResult = false
                    }
                    .buttonStyle(CustomButtonStyle())
                    .hidden()
                }
                Spacer()
            }
        }
    }
    
    func didUserWin(user: Int, computer: Int) -> Bool {
        switch(user) {
        case rock:
            switch(computer) {
            case scissors: return true
            default: return false
            }
        case paper:
            switch(computer) {
            case rock: return true
            default: return false
            }
        case scissors:
            switch(computer) {
            case paper: return true
            default: return false
            }
        default:
            assert(false)
            return false
        }
    }
    
    func didComputerWin(user: Int, computer: Int) -> Bool {
        switch(computer) {
        case rock:
            switch(user) {
            case scissors: return true
            default: return false
            }
        case paper:
            switch(user) {
            case rock: return true
            default: return false
            }
        case scissors:
            switch(user) {
            case paper: return true
            default: return false
            }
        default:
            assert(false)
            return false
        }
    }
    
    func processButton(selection: Int) {
        if !revealResult {
            computerSelection = Int.random(in: 0...2)
            userSelection = selection
            if didUserWin(user: userSelection, computer: computerSelection) {
                winText = "You win"
                if goalIsWinThisTurn {
                    score += 1
                    winText = "You win"
                } else {
                    score -= 1
                    winText = "You win, sorry"
                }
            } else if didComputerWin(user: userSelection, computer: computerSelection) {
                if goalIsWinThisTurn {
                    score -= 1
                    winText = "You lose, sorry"
                } else {
                    score += 1
                    winText = "You lose!"
                }
            } else {
                winText = "Draw"
            }
            revealResult = true
        }
    }
    

}


struct CustomButtonStyle : ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title)
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(5)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
