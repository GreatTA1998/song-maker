//
//  ViewController.swift
//  SwiftPiano
//
//  Created by Deepak on 25/02/17.
//  Copyright © 2017 Deepak. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    var audioPlayer: AVAudioPlayer?
    var audioRecorder: AVAudioRecorder?
    
    @IBOutlet weak var recordButton: UIButton!
    
    @IBAction func recordAudio(_ sender: UIButton) {
        if audioRecorder?.isRecording == false {
            playButton.isEnabled = false
            stopButton.isEnabled = true
            audioRecorder?.record()
        }
    }
    
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction func stopAudio(_ sender: UIButton) {
        stopButton.isEnabled = false
        playButton.isEnabled = true
        recordButton.isEnabled = true
        
        if audioRecorder?.isRecording == true {
            audioRecorder?.stop()
        } else {
            audioPlayer?.stop()
        }
    }
    
    @IBOutlet weak var playButton: UIButton!
    
    @IBAction func playAudio(_ sender: UIButton) {
        if audioRecorder?.isRecording == false {
            stopButton.isEnabled = true
            recordButton.isEnabled = false
            
            do {
                try audioPlayer = AVAudioPlayer(contentsOf:
                    (audioRecorder?.url)!)
                audioPlayer!.delegate = self
                audioPlayer!.prepareToPlay()
                audioPlayer!.play()
            } catch let error as NSError {
                print("audioPlayer error: \(error.localizedDescription)")
            }
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        recordButton.isEnabled = true
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        print("Audio Play Decode Error")
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
    }
    
    func audioRecorderEncodeErrorDidOccur(_ recorder: AVAudioRecorder, error: Error?) {
        print("Audio Record Encode Error")
    }
    
    var chordCount = 1 // used to record the chords with a for loop
    var chordDict = [11: [1,3,5], 12: [2,4,6], 13: [3,5,7], 14:[4,6,8], 15:[5,7,2], 16:[6,8,3], 17:[7,2,4] ]
    var comparisonHarmony = Array(repeating: [0, 0, 0], count: 8) // replaces each chord by its constituent notes to repeatAndCheckMelody()
    
    var chordAudioDict: [Int: [AVAudioPlayer] ] = [Int: [AVAudioPlayer] ]()
    var harmonyAudioArray: [[AVAudioPlayer]] = [[AVAudioPlayer]]() // // can apply playNote() while looping through this array

    var speechCount = 0
    var speechBubbleMessages = ["Hiya, I'm Musicat.", "I'll show you how to write a short song", "These bubbles on the left...", "are the most common chords found in songs","tap them to see how they sound if you want", "Now, press chord I!", "And touch other chords 7 times in any order!", "Touch these 4 notes in any order", "Congrats on your first song!", "Let's send it to someone"]
    @IBOutlet weak var message: UITextView! // this is the speech bubble text
    
    var chordsRecording = false
    var notesRecording = false
    
    var nextCorrectChord = [69, 69, 69, 69, 69, 69, 69, 69, 69, 69, 10, 15, 16, 14, 15, 11, 14] // most common chord after chord 13 is nextCorrectChord[13]
    var nextWrongChords = [ [69], [69], [69], [69], [69], [69], [69], [69], [69], [69], [10], [13,17], [13,17], [12,17], [], [], [12,13,17], [12,13] ] // most disgusting chords after chord [13] is contained in the array, nextWrongChords[13]
    
    var noteCount = 0 // these variables are used in the recordNote function
    var fourNote = [Int]()
    var notesOfBar: [[Int]] = [[Int]]()
    var userHarmony: [Int] = [69] // stores the chord sequence as integers
    var fluteMelodyArr: [Int] = [Int]()
    var fluteAudioDict: [Int: AVAudioPlayer ] = [Int: AVAudioPlayer]()
    var fluteMelodyAudioArr: [AVAudioPlayer] = [AVAudioPlayer]()
    
    var noteAudioDict: [Int: AVAudioPlayer ] = [Int: AVAudioPlayer]()
    var melodyAudioArr: [AVAudioPlayer] = [AVAudioPlayer]()
    var MIDIMelody = Array(repeating: [0,0], count: 32)
    
    var catNoise = AVAudioPlayer()
    var fluteC = AVAudioPlayer()
    var fluteD = AVAudioPlayer()
    var fluteE = AVAudioPlayer()
    var fluteF = AVAudioPlayer()
    var fluteG = AVAudioPlayer()
    var fluteA = AVAudioPlayer()
    var fluteB = AVAudioPlayer()
    var fluteC7 = AVAudioPlayer()
    var C = AVAudioPlayer()
    var D = AVAudioPlayer()
    var Db = AVAudioPlayer()
    var Eb = AVAudioPlayer()
    var E = AVAudioPlayer()
    var F = AVAudioPlayer()
    var G = AVAudioPlayer()
    var A = AVAudioPlayer()
    var B = AVAudioPlayer()
    var C4 = AVAudioPlayer()
    var Gb = AVAudioPlayer()
    var Ab = AVAudioPlayer()
    var Bb = AVAudioPlayer()
    let playCatNoise: NSURL = Bundle.main.url(forResource: "catNoise", withExtension: "mp3")! as NSURL;
    let playfluteC: NSURL = Bundle.main.url(forResource: "fluteC", withExtension: "mp3")! as NSURL;
    let playfluteD: NSURL = Bundle.main.url(forResource: "fluteD", withExtension: "mp3")! as NSURL;
    let playfluteE: NSURL = Bundle.main.url(forResource: "fluteE", withExtension: "mp3")! as NSURL;
    let playfluteF: NSURL = Bundle.main.url(forResource: "fluteF", withExtension: "mp3")! as NSURL;
    let playfluteG: NSURL = Bundle.main.url(forResource: "fluteG", withExtension: "mp3")! as NSURL;
    let playfluteA: NSURL = Bundle.main.url(forResource: "fluteA", withExtension: "mp3")! as NSURL;
    let playfluteB: NSURL = Bundle.main.url(forResource: "fluteB", withExtension: "mp3")! as NSURL;
    let playfluteC7: NSURL = Bundle.main.url(forResource: "fluteC7", withExtension: "mp3")! as NSURL;
    let playC: NSURL = Bundle.main.url(forResource: "C", withExtension: "mp3")! as NSURL;
    let playDb: NSURL = Bundle.main.url(forResource: "C#", withExtension: "mp3")! as NSURL;
    let playD: NSURL = Bundle.main.url(forResource: "D", withExtension: "mp3")! as NSURL;
    let playEb: NSURL = Bundle.main.url(forResource: "D#", withExtension: "mp3")! as NSURL;
    let playE: NSURL = Bundle.main.url(forResource: "E", withExtension: "mp3")! as NSURL;
    let playF: NSURL = Bundle.main.url(forResource: "F", withExtension: "mp3")! as NSURL;
    let playGb: NSURL = Bundle.main.url(forResource: "F#", withExtension: "mp3")! as NSURL;
    let playG: NSURL = Bundle.main.url(forResource: "G", withExtension: "mp3")! as NSURL;
    let playAb: NSURL = Bundle.main.url(forResource: "G#", withExtension: "mp3")! as NSURL;
    let playA: NSURL = Bundle.main.url(forResource: "A", withExtension: "mp3")! as NSURL;
    let playBb: NSURL = Bundle.main.url(forResource: "G#", withExtension: "mp3")! as NSURL;
    let playB: NSURL = Bundle.main.url(forResource: "B", withExtension: "mp3")! as NSURL;
    let playC4: NSURL = Bundle.main.url(forResource: "C4", withExtension: "mp3")! as NSURL
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        let audioSession = AVAudioSession.sharedInstance()
//        
//        do {
//            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
//            
//        }
//            
//        catch{
//            print(error)
//        }
//        
//        
//        playButton.isEnabled = false
//        stopButton.isEnabled = false
//        
//        let fileMgr = FileManager.default
//        
//        let dirPaths = fileMgr.urls(for: .documentDirectory,
//                                    in: .userDomainMask)
//        
//        let soundFileURL = dirPaths[0].appendingPathComponent("sound.caf")
//        
//        let recordSettings =
//            [AVEncoderAudioQualityKey: AVAudioQuality.min.rawValue,
//             AVEncoderBitRateKey: 16,
//             AVNumberOfChannelsKey: 2,
//             AVSampleRateKey: 44100.0] as [String : Any]
//        
//        do {
//            try audioSession.setCategory(
//                AVAudioSessionCategoryPlayAndRecord)
//        } catch let error as NSError {
//            print("audioSession error: \(error.localizedDescription)")
//        }
//        
//        do {
//            try audioRecorder = AVAudioRecorder(url: soundFileURL,
//                                                settings: recordSettings as [String : AnyObject])
//            audioRecorder?.prepareToRecord()
//        } catch let error as NSError {
//            print("audioSession error: \(error.localizedDescription)")
//        }

        createSpeechBubble()
        do { //ignore these
            try catNoise = AVAudioPlayer(contentsOf: playCatNoise as URL)
            catNoise.prepareToPlay()
            try fluteC = AVAudioPlayer(contentsOf: playfluteC as URL)
            fluteC.prepareToPlay()
            try fluteD = AVAudioPlayer(contentsOf: playfluteD as URL)
            fluteC.prepareToPlay()
            try fluteE = AVAudioPlayer(contentsOf: playfluteE as URL)
            fluteC.prepareToPlay()
            try fluteF = AVAudioPlayer(contentsOf: playfluteF as URL)
            fluteC.prepareToPlay()
            try fluteG = AVAudioPlayer(contentsOf: playfluteG as URL)
            fluteC.prepareToPlay()
            try fluteA = AVAudioPlayer(contentsOf: playfluteA as URL)
            fluteC.prepareToPlay()
            try fluteB = AVAudioPlayer(contentsOf: playfluteB as URL)
            fluteC.prepareToPlay()
            try fluteC7 = AVAudioPlayer(contentsOf: playfluteC7 as URL)
            fluteC.prepareToPlay()
            try C = AVAudioPlayer(contentsOf: playC as URL)
            C.prepareToPlay()
            try Db = AVAudioPlayer(contentsOf: playDb as URL)
            Db.prepareToPlay()
            try D = AVAudioPlayer(contentsOf: playD as URL)
            D.prepareToPlay()
            try Eb = AVAudioPlayer(contentsOf: playEb as URL)
            Eb.prepareToPlay()
            try E = AVAudioPlayer(contentsOf: playE as URL)
            E.prepareToPlay()
            try F = AVAudioPlayer(contentsOf: playF as URL)
            F.prepareToPlay()
            try Gb = AVAudioPlayer(contentsOf: playGb as URL)
            Gb.prepareToPlay()
            try G = AVAudioPlayer(contentsOf: playG as URL)
            G.prepareToPlay()
            try Ab = AVAudioPlayer(contentsOf: playAb as URL)
            Ab.prepareToPlay()
            try A = AVAudioPlayer(contentsOf: playA as URL)
            A.prepareToPlay()
            try Bb = AVAudioPlayer(contentsOf: playBb as URL)
            Bb.prepareToPlay()
            try B = AVAudioPlayer(contentsOf: playB as URL)
            B.prepareToPlay()
            try C4 = AVAudioPlayer(contentsOf: playC4 as URL)
            C4.prepareToPlay()
        } catch {}
        
        self.chordAudioDict = [0: [self.C4], 11: [self.C, self.E, self.G], 13: [self.E, self.G, self.B], 14: [self.F, self.A, self.C4], 15: [self.G, self.B, self.D], 16: [self.A, self.C, self.E], ] // do not move before prepareToPlay statements
        self.noteAudioDict = [0: self.C4, 1: self.C, -2: self.Db, 2: self.D, -3: self.Eb, 3: self.E, 4: self.F, -5: self.Gb, 5: self.G, -6: self.Ab, 6: self.A, -7: self.Bb, 7: self.B, 8: self.C4 ]
        self.fluteAudioDict = [1: self.fluteC, 2: self.fluteD, 3: self.fluteE, 4: self.fluteF, 5: self.fluteG, 6: self.fluteA, 7: self.fluteB, 8: self.fluteC7]
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped))
        self.view.addGestureRecognizer(tapGesture) // calls tapped() function whenever user touches any part of the screen other than the buttons
    }

    func tapped(){
        if speechCount < speechBubbleMessages.count - 1 {
            checkMode()
        }
        else {
            print("WOULD GO TO MENU")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkMode() {
        if speechBubbleMessages[speechCount] == "Now, press chord I!" {
            createSpeechBubble()
            IButton.isHighlighted = true //+=1 done by pressing IButton
        }
        if speechBubbleMessages[speechCount] == "And touch other chords 7 times in any order!"{
            message.text = speechBubbleMessages[speechCount]
            chordsRecording = true //+=1 done when harmony completed
        }
        if speechBubbleMessages[speechCount] == "Touch these 4 notes in any order" {
            message.text = speechBubbleMessages[speechCount]
                notesRecording = true
                CButton.isHighlighted = true
                EButton.isHighlighted = true
                GButton.isHighlighted = true
                C4Button.isHighlighted = true // +=1 done when melody completed
        }
        else {
            createSpeechBubble()
            speechCount += 1
        }
    }
    
    func createSpeechBubble() { // loads the next message from the array called speechBubbleMessages
        if speechCount < speechBubbleMessages.count {
            message.text = speechBubbleMessages[speechCount]
        }
    }
    
    @IBAction func chordBoxI(_ sender: UIButton) {
        
        playChordI()
        if speechBubbleMessages[speechCount-1] == "Now, press chord I!"  {
            createSpeechBubble()
            checkMode()
        }
        if chordsRecording == true {
            recordChord(anyButton: sender )
        }
        
    }
    
    func recordChord(anyButton: UIButton){
        if anyButton.titleLabel!.text! == "I" {
        userHarmony.append(11)
            chordCount += 1
        }
        if anyButton.titleLabel!.text! == "III" {
        userHarmony.append(13)
            chordCount += 1
        }
        if anyButton.titleLabel!.text! == "IV" {
        userHarmony.append(14)
            chordCount += 1
        }
        if anyButton.titleLabel!.text! == "V" {
        userHarmony.append(15)
            chordCount += 1
        }
        if anyButton.titleLabel!.text! == "VI" {
        userHarmony.append(16)
            chordCount += 1
        }
        if chordCount == 9 {
            chordsRecording = false // stop recording after user already pressed 8 chords
            checkHarmony()
            convertHarmony()
            self.message.text = "We have chords, now we just need a melody"
            checkMode();
        }
    }
    
    func checkHarmony() {
        for i in 1...6 {
            if nextWrongChords[ userHarmony[i] ].contains( userHarmony[i] ) || userHarmony[i-1] == userHarmony[i] {
                userHarmony[i] = nextCorrectChord[ userHarmony[i] ]
                print("Corrected chord \(userHarmony[i]) to \(nextCorrectChord[ userHarmony[i] ])")
            }
        }
        print("userHarmony before the bug is \(userHarmony)")
        userHarmony[7] = 15
        userHarmony[8] = 11
        userHarmony.remove(at: 0)
        
    }
    
    func recordNote(anyButton: UIButton) {
        fourNote.append(Int(anyButton.titleLabel!.text!)!)
        noteCount += 1
        
        if noteCount == 4 {
            
        notesRecording = false
        repeatAndCheckMelody()
        
        convertMelody() //convert to an audio array before playing to prevent lag
        convertHarmony()
            
        let delay = DispatchTime.now() + 0.85 //play everything
        DispatchQueue.main.asyncAfter(deadline: delay) {
           self.playMelody()
        }
        playHarmony()
        playFluteMelody()
        
        speechCount += 1 //progresses through the timeline
        checkMode()
        }
    }

    func algorithmX(b: Int, instability: Int) {
        var corrections = 0
        for i in 0...3 {
            if comparisonHarmony[b].contains(notesOfBar[b][i]) == false { //2nd note of bar 3 is notesOfBar[3][2]
                var gapArray: [Int] = [Int]()
                for j in 0...2 {
                    gapArray.append(abs(comparisonHarmony[b][j] - notesOfBar[b][i] ) )
                }
                let k = gapArray.min() as Int!
                
                let index = gapArray.index(of: k!)
                notesOfBar[b][i] = comparisonHarmony[b][index!] //corrects mistake to the nearest acceptable note
                corrections += 1
                if (instability - corrections) == 1 { // for instability = 1,  the algorithm ensures the first beat is stable
                    break
                }
            }
        }
    }
    
    func repeatAndCheckMelody() {
        for _ in 0...7 {
            notesOfBar.append(fourNote)
        }
        
        print("MELODY BEFORE CORRECTION IS \(notesOfBar)")

        for bar in 0...7 { // first of all, check the number of unstable notes
            
            var instability = 0
            
            for i in 0...3 { // calculate instability of each bar's melody
                if comparisonHarmony[bar].contains(notesOfBar[bar][i]) == false {
                    instability += 1
                }
            }
            
            print("unstable is \(instability))")
            
            if instability == 1 {
                algorithmX(b: bar, instability: 1)
            }
            if instability == 2 {
                algorithmX(b: bar, instability: 2)
            }
            if instability == 3 {
                algorithmX(b: bar, instability: 3)
            }
            
            if instability == 4 {
                algorithmX(b: bar, instability: 4)
            }
        }
        print("MELODY AFTER CORRECTION IS \(notesOfBar)")
        print("USERHARMONY IS \(userHarmony)")
    }
    
    func convertMelody() {
        var flattened = notesOfBar.flatMap { $0 }
        for i in 0...31 {
            melodyAudioArr.append(noteAudioDict[ flattened[i] ]! )
        }
        for j in 0...31 where j%4 == 0 {
            fluteMelodyArr.append(flattened[j])
            print("FLUTEMELODYARRAY IS \(fluteMelodyArr)")
        }
        for k in 0...7 {
        fluteMelodyAudioArr.append( fluteAudioDict[ fluteMelodyArr[k] ]! )
        }
    }
    
    func convertHarmony() {
        for i in 0...7 {
            comparisonHarmony[i] = chordDict[ userHarmony[i] ]!
            harmonyAudioArray.append(chordAudioDict[userHarmony [i] ]! )
        }
    }
    
    func playMelody() {
        var i = -1
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) {
                timer in i += 1
                self.playNote(audioPlayer: self.melodyAudioArr[i] )
                if i == self.melodyAudioArr.count-1 {
                    timer.invalidate()
                }
            }
        }
        else {
            // Fallback on earlier versions
        }
    }

    func playHarmony() {
        var i = -1
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) {
                timer in i += 1
                for j in 0...2 { // plays the 3 constituent notes
                    self.playNote(audioPlayer: self.harmonyAudioArray[i][j])
                    if i == self.userHarmony.count-1 { // ie. when i == 7
                        timer.invalidate()
                    }
                }
            }
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    func playFluteMelody() {
        var i = -1
        
        if #available(iOS 10.0, *) {
            Timer.scheduledTimer(withTimeInterval: 1.2, repeats: true) {
                timer in i += 1
                self.playShortNote(audioPlayer: self.fluteMelodyAudioArr[i], duration: 3.8, volume: 1.0)
                if i == 7 {
                        timer.invalidate()
                }
            }
        }
        else {
            // Fallback on earlier versions
        }
    }
    
    
    func convertToRhythmicMelody() {
        for i in 0...7 {
            var k = 0
            for j in 0...3 {
    MIDIMelody[(i*4)+j][0] = notesOfBar[i][j]
    MIDIMelody[(i*4)+j][1] = 5000000*k + 5000 // CHANGE RHYTHM HERE
                k += 200
            }
        }
        print(MIDIMelody)
    }
    
//    func playRhythmicMelody() {
//        for i in 0...31 {
//            let now = DispatchTime.now()
//            let notNow = CFAbsoluteTimeGetCurrent()
//            let delay: TimeInterval = Timer(5)
//            print("delay is \(delay)")
//            playAtSpecificTime(audioplayer: noteAudioDict [ MIDIMelody[i][0] ]!, Delay: delay )
//        }
//    }
    
    func playSong() {
        // playAtSpecificTime()
    }
    
    func playAtSpecificTime(audioplayer: AVAudioPlayer, Delay: TimeInterval) {
        print("DELAY IS \(Delay)")
        audioplayer.currentTime = 0
        audioplayer.play(atTime: Delay)
    }
    
    func playShortNote(audioPlayer: AVAudioPlayer,  duration: Double, volume: Float) {
        audioPlayer.currentTime = duration
        audioPlayer.volume = volume
        audioPlayer.play()
    }
    
    func playNote(audioPlayer: AVAudioPlayer) {
        audioPlayer.currentTime=0
        audioPlayer.play()
        audioPlayer.volume = 0.8
    }
    
    @IBAction func playButton(_ sender: Any) {
        let delay = DispatchTime.now() + 0.85
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.playMelody()
        }
        playHarmony()
        playFluteMelody()
    }
    
    @IBAction func melodyButton(_ sender: Any) {
        //playRhythmicMelody()
    }
    
    @IBAction func C(_ sender: UIButton) {
        playNote(audioPlayer: C)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func Db(_ sender: UIButton) {
        playNote(audioPlayer: Db)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func D(_ sender: UIButton) {
        playNote(audioPlayer: D)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func Eb(_ sender: UIButton) {
        playNote(audioPlayer: Eb)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func E(_ sender: UIButton){
         playNote(audioPlayer: E)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func F(_ sender: UIButton) {
        playNote(audioPlayer: F)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func Gb(_ sender: UIButton) {
        playNote(audioPlayer: Gb)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func Ab(_ sender: UIButton) {
        playNote(audioPlayer: Ab)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func Bb(_ sender: UIButton) {
        playNote(audioPlayer: Bb)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func G(_ sender: UIButton) {
        playNote(audioPlayer: G)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func A(_ sender: UIButton) {
        playNote(audioPlayer: A)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func B(_ sender: UIButton) {
        playNote(audioPlayer: B)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
    @IBAction func C4(_ sender: UIButton) {
        playNote(audioPlayer: C4)
        if notesRecording == true {
            recordNote(anyButton: sender )
        }
    }
  
    @IBOutlet weak var IButton: UIButton!
    @IBOutlet weak var CButton: UIButton!
    @IBOutlet weak var DButton: UIButton!
    @IBOutlet weak var EButton: UIButton!
    @IBOutlet weak var FButton: UIButton!
    @IBOutlet weak var GButton: UIButton!
    @IBOutlet weak var AButton: UIButton!
    @IBOutlet weak var BButton: UIButton!
    @IBOutlet weak var C4Button: UIButton!
    
   
    @IBAction func chordBoxIII(_ sender: UIButton) {
        playChordIII()
        if chordsRecording == true { // during "harmonyTime" mode, the chord boxes the user taps are recorded in an array
            recordChord(anyButton: sender )
        }
    }
    @IBAction func chordBoxIV(_ sender: UIButton) {
        playChordIV()
        if chordsRecording == true {
            recordChord(anyButton: sender )
        }
    }
    @IBAction func chordBoxV(_ sender: UIButton) {
        playChordV()
        if chordsRecording == true {
            recordChord(anyButton: sender )
        }
    }
    @IBAction func chordBoxVI(_ sender: UIButton) {
        playChordVI()
        if chordsRecording == true {
            recordChord(anyButton: sender )
        }
    }
    func playChordI() {
        CButton.isHighlighted = true
        EButton.isHighlighted = true
        GButton.isHighlighted = true
        CButton.sendActions(for: .touchDown)
        EButton.sendActions(for: .touchDown)
        GButton.sendActions(for: .touchDown)
        let delay = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.CButton.isHighlighted = false
            self.EButton.isHighlighted = false
            self.GButton.isHighlighted = false
        }
    }
    func playChordIII() {
        EButton.isHighlighted = true
        GButton.isHighlighted = true
        BButton.isHighlighted = true
        EButton.sendActions(for: .touchDown)
        GButton.sendActions(for: .touchDown)
        BButton.sendActions(for: .touchDown)
        let delay = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.EButton.isHighlighted = false
            self.GButton.isHighlighted = false
            self.BButton.isHighlighted = false
        }
    }
    func playChordIV() {
        FButton.isHighlighted = true
        AButton.isHighlighted = true
        C4Button.isHighlighted = true
        FButton.sendActions(for: .touchDown)
        AButton.sendActions(for: .touchDown)
        C4Button.sendActions(for: .touchDown)
        let delay = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.FButton.isHighlighted = false
            self.AButton.isHighlighted = false
            self.C4Button.isHighlighted = false
        }
    }
    func playChordV() {
        GButton.isHighlighted = true
        BButton.isHighlighted = true
        DButton.isHighlighted = true
        GButton.sendActions(for: .touchDown)
        BButton.sendActions(for: .touchDown)
        DButton.sendActions(for: .touchDown)
        let delay = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: delay) {
            self.GButton.isHighlighted = false
            self.BButton.isHighlighted = false
            self.DButton.isHighlighted = false
            }
    }
    func playChordVI() {
            AButton.isHighlighted = true
            CButton.isHighlighted = true
            EButton.isHighlighted = true
            AButton.sendActions(for: .touchDown)
            CButton.sendActions(for: .touchDown)
            EButton.sendActions(for: .touchDown)
            let delay = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: delay) {
                self.AButton.isHighlighted = false
                self.CButton.isHighlighted = false
                self.EButton.isHighlighted = false
            }
    }
}


