//
//  ContentView.swift
//  RockPaper
//
//  Created by Ian Bailey on 4/9/2022.
//

import SwiftUI

// Some terminology: a "shape" is the shape made with the hand
// in each "play" of the game




enum Shape: String {
    case rock = "🪨"
    case paper = "📃"
    case scissors = "✂️"
    
    static func random() -> Shape {
        switch Int.random(in: 0...2) {
            case 0: return self.rock
            case 1: return self.paper
            default: return self.scissors
        }
    }
}



struct ContentView: View {
    @State var score = 0
    @State var goalIsWinThisTurn = Bool.random()
    @State var userSelection: Shape = .rock
    @State var computerSelection: Shape = .rock
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
                    Button(Shape.rock.rawValue) {
                        processButton(selection: .rock)
                    }
                    Spacer()
                    Button(Shape.paper.rawValue) {
                        processButton(selection: .paper)
                    }
                    Spacer()
                    Button(Shape.scissors.rawValue){
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

    
    func processButton(selection: Shape) {
        if !revealResult {
            computerSelection = Shape.random()
            userSelection = selection
            numberOfPlays += 1
            showScores = (numberOfPlays == 10)
            if didUserWin(user: userSelection, computer: computerSelection) {
                if goalIsWinThisTurn {
                    score += 1
                    winText = "You win!"
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


func didUserWin(user: Shape, computer: Shape) -> Bool {
    switch user {
    case .rock:
        switch computer {
        case .scissors: return true
        default: return false
        }
    case .paper:
        switch computer {
        case .rock: return true
        default: return false
        }
    case .scissors:
        switch computer {
        case .paper: return true
        default: return false
        }
    }
}


func didComputerWin(user: Shape, computer: Shape) -> Bool {
    switch computer {
    case .rock:
        switch user  {
        case .scissors: return true
        default: return false
        }
    case .paper:
        switch user  {
        case .rock: return true
        default: return false
        }
    case .scissors:
        switch user  {
        case .paper: return true
        default: return false
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
