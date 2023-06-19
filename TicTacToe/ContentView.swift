//
//  ContentView.swift
//  TicTacToe
//
//  Created by Gianna Stylianou on 17/6/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TicTacToeViewModel()
    @State private var isNameInputVisible = true

    var body: some View {
        GeometryReader { geometry in
            VStack {
                if isNameInputVisible {
                    PlayerNameInputView(isNameInputVisible: $isNameInputVisible, viewModel: viewModel)
                } else {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.clear)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.black, lineWidth: 2)
                            )
                        Text(viewModel.messageToShow)
                            .font(.system(size: 20))
                            .bold()
                            .padding()
                    }.frame(width: 350, height: 70)

                    Spacer()

                    HStack {
                        Image("X_score")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(viewModel.xPlayerName): \(viewModel.xPlayerScore)")
                            .font(.title)
                            .bold()
                            .padding()
                    }

                    let borderSize = CGFloat(5)
                    VStack(spacing: borderSize) {
                        ForEach(0...2, id: \.self) { row in
                            HStack(spacing: borderSize) {
                                ForEach(0...2, id: \.self) { col in
                                    Image(viewModel.gameState[row][col].tileType.tileIcon)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .aspectRatio(1.1, contentMode: .fit)
                                        .foregroundColor(.black)
                                        .background(Color.gray.opacity(0.1).cornerRadius(20.0))
                                        .imageScale(.small)
                                        .onTapGesture {
                                            viewModel.placeTile(x: row, y: col)
                                        }
                                }
                            }
                        }
                    }
                    .padding()
                    .alert(isPresented: $viewModel.displayMessage) {
                        Alert(title: Text(viewModel.messageToShow), dismissButton: .default(Text("OK")) {
                            viewModel.resetGame()
                        })
                    }

                    HStack {
                        Image("O_score")
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("\(viewModel.oPlayerName): \(viewModel.oPlayerScore)")
                            .font(.title)
                            .bold()
                            .padding()
                    }

                    Spacer()
                }
            }
        }
    }
}

struct PlayerNameInputView: View {
    @Binding var isNameInputVisible: Bool
    @ObservedObject var viewModel: TicTacToeViewModel
    @State private var xPlayerName: String = ""
    @State private var oPlayerName: String = ""

    var body: some View {
        VStack {
            Spacer()
            Image("header")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 180, height: 100)
            Spacer()
            TextField("X Player Name", text: $xPlayerName)
                .font(.system(size: 20))
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            TextField("O Player Name", text: $oPlayerName)
                .font(.system(size: 20))
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: saveNames) {
                Text(GameStateMessage.start.rawValue)
                    .font(.system(size: 24))
                    .bold()
            }
            .padding()
            
            Spacer()
        }
    }

    func saveNames() {
        if xPlayerName.isEmpty || oPlayerName.isEmpty {
            // Show alert message if either of the name fields are empty
            showAlert()
        } else {
            viewModel.xPlayerName = xPlayerName
            viewModel.oPlayerName = oPlayerName
            viewModel.startGame()
            isNameInputVisible = false
        }
    }
    
    func showAlert() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootViewController = windowScene.windows.first?.rootViewController {
            let alert = UIAlertController(title: "Error", message: "Please enter a name for both players", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            rootViewController.present(alert, animated: true, completion: nil)
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
