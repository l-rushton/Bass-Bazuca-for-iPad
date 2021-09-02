//
// AudioKit file, containing the sequencer and
//
//
import AudioKit

open class SequencerInstrument {
    //array to keep track of which notes are enabled, similar to mono array in viewcontroller
    var beats: Array<Bool> = Array(repeating: false, count: 8)
    //array to store pitch data of corresponding beat
    var pitches: Array<MIDINoteNumber> = Array(repeating: 0, count: 8)
    
    //initialise sequencers for each oscillator
    var sineSequencer: AKAppleSequencer = AKAppleSequencer()
    var sawSequencer: AKAppleSequencer = AKAppleSequencer()
    var triangleSequencer: AKAppleSequencer = AKAppleSequencer()
    var squareSequencer: AKAppleSequencer = AKAppleSequencer()
    
    //initialise tracks to be filled for sequence
    var sineTrack: AKMusicTrack!
    var sawTrack: AKMusicTrack!
    var squareTrack: AKMusicTrack!
    var triangleTrack: AKMusicTrack!
    
    //couldnt get my head around why but in order to control the volumes of each oscillator
    //they each needed their own mixer before each of those then get routed through the
    //osc mixer
    var sineMixer: AKMixer!
    var squareMixer: AKMixer!
    var sawMixer: AKMixer!
    var triangleMixer: AKMixer!
    
    //initialise parent mixer and two children for drums and synth parts
    var mixer: AKMixer!
    var oscMixer: AKMixer!
    var drumMixer: AKMixer!
    
    //initialise midi node for each oscillator
    var midiNodeSine: AKMIDINode!
    var midiNodeSaw: AKMIDINode!
    var midiNodeSquare: AKMIDINode!
    var midiNodeTriangle: AKMIDINode!
    
    //initialise oscillators
    var sineOscillator = AKOscillatorBank(waveform: AKTable(.sine), attackDuration: 0.1, decayDuration: 0.1, sustainLevel: 0.1, releaseDuration: 0.1, pitchBend: 0, vibratoDepth: 0, vibratoRate: 0)
    var sawOscillator = AKOscillatorBank(waveform: AKTable(.sawtooth), attackDuration: 0.1, decayDuration: 0.1, sustainLevel: 0.1, releaseDuration: 0.1, pitchBend: 0, vibratoDepth: 0, vibratoRate: 0)
    var squareOscillator = AKOscillatorBank(waveform: AKTable(.square), attackDuration: 0.1, decayDuration: 0.1, sustainLevel: 0.1, releaseDuration: 0.1, pitchBend: 0, vibratoDepth: 0, vibratoRate: 0)
    var triangleOscillator = AKOscillatorBank(waveform: AKTable(.triangle), attackDuration: 0.1, decayDuration: 0.1, sustainLevel: 0.1, releaseDuration: 0.1, pitchBend: 0, vibratoDepth: 0, vibratoRate: 0)
    
    //initialise drum files to be played
    var houseLoop: AKAudioPlayer!
    var house2Loop: AKAudioPlayer!
    var house3Loop: AKAudioPlayer!
    var technoLoop: AKAudioPlayer!
    var garageLoop: AKAudioPlayer!
    var garage2Loop: AKAudioPlayer!
    
    //function for adding note to sequence
    func addNote(beatToAdd: AKDuration, pitchOfBeat: MIDINoteNumber) {
        //take position and pitch and add it to all the sequencer-oscillators
        sineTrack?.add(noteNumber: pitchOfBeat, velocity: 127, position: beatToAdd, duration: AKDuration(beats:0.7))
        sawTrack?.add(noteNumber: pitchOfBeat, velocity: 127, position: beatToAdd, duration: AKDuration(beats:0.7))
        triangleTrack?.add(noteNumber: pitchOfBeat, velocity: 127, position: beatToAdd, duration: AKDuration(beats:0.7))
        squareTrack?.add(noteNumber: pitchOfBeat, velocity: 127, position: beatToAdd, duration: AKDuration(beats:0.7))
        
        //position represents what beat it lands on
         let position = Int(beatToAdd.seconds)
        //update pitch array
         pitches[position] = pitchOfBeat
        //update beat array
         beats[position] = true
     }
    
    //function for deleting note from sequence
     func deleteNote(beatToRemove: AKDuration) {
        //take position to delete
         let position = Int(beatToRemove.seconds)
        //update beat array
        beats[position] = false
        //update pitch array
         pitches[position]  = 0
        
        //clear entire sequence
         sineTrack?.clear()
        
        //re add notes using data from pitch and beat arrays
         for i in 0...7 {
             if (beats[i] == true) {
                sineTrack?.add(noteNumber: pitches[i], velocity: 127, position: AKDuration(beats:Double(i)), duration: AKDuration(beats:0.7))
             }
         }
        
        sawTrack?.clear()
        for i in 0...7 {
            if (beats[i] == true) {
               sawTrack?.add(noteNumber: pitches[i], velocity: 127, position: AKDuration(beats:Double(i)), duration: AKDuration(beats:0.7))
            }
        }

        squareTrack?.clear()
        for i in 0...7 {
            if (beats[i] == true) {
               squareTrack?.add(noteNumber: pitches[i], velocity: 127, position: AKDuration(beats:Double(i)), duration: AKDuration(beats:0.7))
            }
        }
        
        triangleTrack?.clear()
        for i in 0...7 {
            if (beats[i] == true) {
               triangleTrack?.add(noteNumber: pitches[i], velocity: 127, position: AKDuration(beats:Double(i)), duration: AKDuration(beats:0.7))
            }
        }
        
     }

    init() {
        
        //initialise arrays
        for i in 0...7 {
            beats[i]  = false
            pitches[i] = 0
        }
        
        //assign drum files to variables
        let house2File = try! AKAudioFile(readFileName: "deep house.wav", baseDir: .resources)
        let house3File = try! AKAudioFile(readFileName: "house 2.wav", baseDir: .resources)
        let technoFile = try! AKAudioFile(readFileName: "techno.wav", baseDir: .resources)
        let garageFile = try! AKAudioFile(readFileName: "garage.wav", baseDir: .resources)
        let garage2File = try! AKAudioFile(readFileName: "garage 2.wav", baseDir: .resources)
        let houseLoopFile = try! AKAudioFile(readFileName: "house loop.wav", baseDir: .resources)
        
        //initialise audio players in correspondance to the files
        houseLoop = try! AKAudioPlayer(file: houseLoopFile)
        house2Loop = try! AKAudioPlayer(file: house2File)
        house3Loop = try! AKAudioPlayer(file: house3File)
        technoLoop = try! AKAudioPlayer(file: technoFile)
        garageLoop = try! AKAudioPlayer(file: garageFile)
        garage2Loop = try! AKAudioPlayer(file: garage2File)
        
        //enable looping
        houseLoop.looping = true
        house2Loop.looping = true
        house3Loop.looping = true
        technoLoop.looping = true
        garageLoop.looping = true
        garage2Loop.looping = true
        
        //midi nodes to allow the oscillators to be triggered by the sequence
        midiNodeSine = AKMIDINode(node: sineOscillator)
        midiNodeSaw = AKMIDINode(node: sawOscillator)
        midiNodeSquare = AKMIDINode(node: squareOscillator)
        midiNodeTriangle = AKMIDINode(node: triangleOscillator)

        //as previously mentioned, in order to gain control of individual volumes
        //each oscillator needs its own dedicated preliminary mixer
        sineMixer = AKMixer(sineOscillator)
        squareMixer = AKMixer(squareOscillator)
        sawMixer = AKMixer(sawOscillator)
        triangleMixer = AKMixer(triangleOscillator)
        
        //oscillator mixer to combine each oscillator
        oscMixer = AKMixer(sineMixer, squareMixer, sawMixer, triangleMixer)
        
        //drum mixer to combine all the loops
        drumMixer = AKMixer(houseLoop, house2Loop, house3Loop, technoLoop, garageLoop, garage2Loop)
        
        //parent mixer
        mixer = AKMixer(oscMixer, drumMixer)
        
        //link it to output
        AudioKit.output = mixer

        //assign track variables to newtracks for each sequencer
        sineTrack = sineSequencer.newTrack()
        sawTrack = sawSequencer.newTrack()
        triangleTrack = triangleSequencer.newTrack()
        squareTrack = squareSequencer.newTrack()
        
        //enable looping for the sequencers
        sineSequencer.enableLooping(AKDuration(beats: 8))
        sawSequencer.enableLooping(AKDuration(beats: 8))
        squareSequencer.enableLooping(AKDuration(beats: 8))
        triangleSequencer.enableLooping(AKDuration(beats: 8))
        
        //assign sequencer midi outputs to corresponding midi nodes
        sineSequencer.setGlobalMIDIOutput(midiNodeSine.midiIn)
        sawSequencer.setGlobalMIDIOutput(midiNodeSaw.midiIn)
        squareSequencer.setGlobalMIDIOutput(midiNodeSquare.midiIn)
        triangleSequencer.setGlobalMIDIOutput(midiNodeTriangle.midiIn)
        
        //set BPM, which all the beats were made to
        sineSequencer.setTempo(120)
        sawSequencer.setTempo(120)
        squareSequencer.setTempo(120)
        triangleSequencer.setTempo(120)
        
        try!AudioKit.start()
    }
    
    //set drum/osc mixer volumes
    open func setElementVolume(forElement: Int, toVolume: Float) {
        switch forElement{
            case 1: oscMixer.volume = Double(toVolume)
            case 2: drumMixer.volume = Double(toVolume)
            default: print("error")
        }
    }
    
    //set oscillator volumes
    open func setOscVolume(forElement: Int, toVolume: Float) {
        switch forElement{
            case 1: sineMixer.volume = Double(toVolume)
            case 2: sawMixer.volume = Double(toVolume)
            case 3: squareMixer.volume = Double(toVolume)
            case 4: triangleMixer.volume = Double(toVolume)
            default: print("error")
        }
    }
    
    //function to play drum loops
    open func drumPlay(){
        houseLoop.play()
        house2Loop.play()
        house3Loop.play()
        technoLoop.play()
        garageLoop.play()
        garage2Loop.play()
    }
    
    //funtion to stop drum loops
    open func drumStop(){
        houseLoop.stop()
        house2Loop.stop()
        house3Loop.stop()
        technoLoop.stop()
        garageLoop.stop()
        garage2Loop.stop()
    }
    
    //function for setting which loop plays
    open func setLoop(forElement: Int) {
        switch forElement{
        case 1: houseLoop.volume = 0.8
                 house2Loop.volume = 0
                 house3Loop.volume = 0
                 technoLoop.volume = 0
                 garageLoop.volume = 0
                 garage2Loop.volume = 0
            
            case 2: houseLoop.volume = 0
            house2Loop.volume = 0.8
                 house3Loop.volume = 0
                 technoLoop.volume = 0
                 garageLoop.volume = 0
                 garage2Loop.volume = 0
            
            case 3: houseLoop.volume = 0
                 house2Loop.volume = 0
                 house3Loop.volume = 0.8
                 technoLoop.volume = 0
                 garageLoop.volume = 0
                 garage2Loop.volume = 0
            
            case 4: houseLoop.volume = 0
                 house2Loop.volume = 0
                 house3Loop.volume = 0
                 technoLoop.volume = 0.8
                 garageLoop.volume = 0
                 garage2Loop.volume = 0
            
            case 5: houseLoop.volume = 0
                 house2Loop.volume = 0
                 house3Loop.volume = 0
                 technoLoop.volume = 0
                 garageLoop.volume = 0.8
                 garage2Loop.volume = 0
            
            case 6: houseLoop.volume = 0
                 house2Loop.volume = 0
                 house3Loop.volume = 0
                 technoLoop.volume = 0
                 garageLoop.volume = 0
                 garage2Loop.volume = 0.8
            
            case 7: houseLoop.volume = 0
                 house2Loop.volume = 0
                 house3Loop.volume = 0
                 technoLoop.volume = 0
                 garageLoop.volume = 0
                 garage2Loop.volume = 0
            
            default: print("error")
        }
    }
}


