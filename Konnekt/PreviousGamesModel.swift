//
//  PreviousGamesModel.swift
//  Konnekt
//
//  Created by Tom on 27/06/2017.
//  Copyright © 2017 Tom23. All rights reserved.
//

//  model for the previous games played, includes scores and images
// 10 previous games held at any 1 time

import Foundation
import UIKit

class PreviousGamesModel {
    
    private let userDefaultImagesKey = "Konnekt_Previous_Game_Images_Paths"
    private let userDefaultScoresKey = "Konnekt_Previous_Game_Scores"
    
    private (set) var previousScores: [Int] = []              // array of previous scores, in order
                                                // of latest game last
    private (set) var previousGameImages: [UIImage] = []      // array of previous game images
                                                // in order of latest game last
    
    private var previousGameImagePaths: [String] = []   // array of previous game image paths, used
                                                        // for storing
    
    
    private var documentsDirectory: URL!
    
    // initalize, load the scores and images using userdefaults stores arrays
    init() {
        
        // get the documents directory
        documentsDirectory = getDocumentsDirectory()
        
        // check if the user defaults score array exists
        let scoresArray = UserDefaults.standard.array(forKey: userDefaultScoresKey)
        
        if scoresArray != nil {
            previousScores = scoresArray as! [Int]
        }
        
        // check if the user defaults image array exists
        let imageArray = UserDefaults.standard.array(forKey: userDefaultImagesKey)
        
        if imageArray != nil {
            // set previous game image paths array
            self.previousGameImagePaths = imageArray as! [String]
            
            // create the uiimages from the paths
            for path in self.previousGameImagePaths {
                let imageUrl = getDocumentsDirectory().appendingPathComponent(path)
                print(imageUrl.path)
                let image = UIImage(contentsOfFile: imageUrl.path)
                
                // add the image to the array
                self.previousGameImages.append(image!)
            }
        }
    }
    
    // new score posted, add to array, remove first/oldest game, save the image, 
    // delete the oldest image
    func addNewScore(score: Int, image: UIImage) {
        
        //temp 
        #if arch(i386) || arch(x86_64)
            let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
            NSLog("Document Path: %@", documentsPath)
        #endif
        
        // save the score to the score array
        self.previousScores.append(score)
        
        // if more than 10 score remove the first
        if self.previousScores.count > 10 {
            self.previousScores.removeFirst()
        }
        
        // update the user defaults
        UserDefaults.standard.set(self.previousScores, forKey: userDefaultScoresKey)
        
        // save the image to the documents directory
        let newImageName = saveImage(image: image)
        
        // add the new image to the array of previous game images
        self.previousGameImagePaths.append(newImageName)
        
        // add the uiimae to the array
        self.previousGameImages.append(image)
        
        // if array is longer than 10 paths remove the first
        if self.previousGameImagePaths.count > 10 {
            
            // remove oldest from array
            let removeName = self.previousGameImagePaths.removeFirst()
            
            // path of file to remove
            let path = getDocumentsDirectory().appendingPathComponent(removeName)
            
            // remove the file
            try? FileManager.default.removeItem(at: path)
        }
        
        // resave the array in the User Defaults
        UserDefaults.standard.set(self.previousGameImagePaths, forKey: userDefaultImagesKey)
        
        // resync the user defaults
        UserDefaults.standard.synchronize()
    }
    
    // returns an array of scores and images
    func getPreviousGames() -> [GameScore] {
        
        var returnArray: [GameScore] = []
        
        //create the game score to return by looping through the arrays
        for i in 0 ..< previousScores.count {
            let gameScore = GameScore(score: previousScores[i])
            gameScore.image = previousGameImages[i]
            
            returnArray.append(gameScore)
        }
        
        return returnArray
    }
    
    
    // get the location of the apps documents directory, for saving and retreving
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    // save an image to the documents directory, returns the string name of the file
    private func saveImage(image: UIImage) -> String {
        // create a png data stream
        let png = UIImagePNGRepresentation(image)
        
        // generate a random name for the file
        let name = randomAlphaNumericString(length: 10)
        
        // create the whole file path
        let filepath = getDocumentsDirectory().appendingPathComponent(name + ".png")
        
        // try to save the file
        try? png?.write(to: filepath)
        
        // return the name of the file without the path
        return name + ".png"
    }
    
    // generate a random string
    private func randomAlphaNumericString(length: Int) -> String {
        let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let allowedCharsCount = UInt32(allowedChars.characters.count)
        var randomString = ""
        
        for _ in 0..<length {
            let randomNum = Int(arc4random_uniform(allowedCharsCount))
            let randomIndex = allowedChars.index(allowedChars.startIndex, offsetBy: randomNum)
            let newCharacter = allowedChars[randomIndex]
            randomString += String(newCharacter)
        }
        
        return randomString
    }
}
