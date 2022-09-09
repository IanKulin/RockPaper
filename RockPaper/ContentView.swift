//
//  ContentView.swift
//  RockPaper
//
//  Created by Ian Bailey on 4/9/2022.
//

import SwiftUI

// Some terminology: a "shape" is the shape made with the hand
// in each "play" of the game




enum FingerShape: String {
    case rock = "🪨"
    case paper = "📃"
    case scissors = "✂️"
    
    static func random() -> FingerShape {
        switch Int.random(in: 0...2) {
            case 0: return self.rock
            case 1: return self.paper
            default: return self.scissors
        }
    }
}


enum GameResult {
    case win
    case loss
    case draw
}



struct ContentView: View {
    @State var score = 0
    @State var goalIsWinThisTurn = Bool.random()
    @State var userSelection: FingerShape = .rock
    @State var computerSelection: FingerShape = .rock
    @State var winText = ""
    @State var numberOfPlays = 0
    @State var showScores = false


    // game has two modes - revealResult - buttons don't work, and we can see the computer result
    // or !revealResult - user can chose their play
    @State var revealResult = false
    
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [.white, .gray], startPoint: .top, endPoint: .bottom)
            VStack{
                if showScores {
                    Text("Score: \(score)")
                    .font(.title)
                    .foregroundColor(.primary)
                } else {
                    Text("Score: \(score)")
                    .font(.title)
                    .hidden()
                }
                
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
                    Button(FingerShape.rock.rawValue) {
                        processButton(selection: .rock)
                    }
                    Spacer()
                    Button(FingerShape.paper.rawValue) {
                        processButton(selection: .paper)
                    }
                    Spacer()
                    Button(FingerShape.scissors.rawValue){
                        processButton(selection: .scissors)
                    }
                    Spacer()
                }.font(.system(size: 60))
                
                Spacer()
                if revealResult {
                    Text(computerSelection.rawValue)
                        .font(.system(size: 200))
                    Text(winText).font(.title)
                    Spacer()
                    Button("Play again") {
                        goalIsWinThisTurn = Bool.random()
                        revealResult = false
                        if showScores {
                            score = 0
                            numberOfPlays = 0
                            showScores.toggle()
                        }
                    }
                    .buttonStyle(CustomButtonStyle())
                }
                else {
                    Text(computerSelection.rawValue)
                        .font(.system(size: 200))
                        .hidden()
                    Text(winText)
                        .font(.title)
                        .hidden()
                    Spacer()
                    Button("Play again") {
                    }
                    .buttonStyle(CustomButtonStyle())
                    .hidden()
                }
                Spacer()
            }
        }
    }

    
    func processButton(selection: FingerShape) {
        if !revealResult {
            computerSelection = FingerShape.random()
            numberOfPlays += 1
            showScores = (numberOfPlays == 10)
            let result = gameResult(user: selection, computer: computerSelection)
            switch result {
            case .win :
                if goalIsWinThisTurn {
                    score += 1
                    winText = "You win!"
                } else {
                    score -= 1
                    winText = "You win, sorry"
                }
            case .loss:
                if goalIsWinThisTurn {
                    score -= 1
                    winText = "You lose, sorry"
                } else {
                    score += 1
                    winText = "You lose!"
                }
            case .draw: winText = "Draw"
            }
            revealResult = true
        }
    }

}


func gameResult(user: FingerShape, computer: FingerShape) -> GameResult {
    switch user {
    case .rock:
        switch computer {
        case .rock: return .draw
        case .paper: return .loss
        case .scissors: return .win
       }
    case .paper:
        switch computer {
            case .rock: return .win
            case .paper: return .draw
            case .scissors: return .loss
        }
    case .scissors:
            switch computer {
            case .rock: return .loss
            case .paper: return .win
            case .scissors: return .draw
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
