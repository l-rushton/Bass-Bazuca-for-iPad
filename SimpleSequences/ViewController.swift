//
// Y3858557 BASS SEQUENCER
// ENTER THE BASS BAZUCA
// PLEASE RUN HORIZONTALLY ON IPAD 7th GEN
import UIKit
import AudioKit

//beat variable to aid with passing the position of selected cell to sequencer
var beat: AKDuration = AKDuration(beats:0)
//pitch variable for much the same reasons, each cell has its pitch which must also be passed
//into the sequencer
var pitch: MIDINoteNumber = MIDINoteNumber(0)
//8 beat long boolean array used by mono checker function to keep track of which beats are occupied
//index corresponds to beats and if true that means a note resides there
var monoCheckArray: Array<Bool> = Array(repeating: false, count: 8)
//bool for aiding the function of the start stop button and syncing it with the drum samples
var drumLoop: Bool = false

class ViewController: UIViewController {
    //instantiate sequencer instrument class
    var sequencer: SequencerInstrument = SequencerInstrument()
    
    //play pause action
    @IBAction func playPause(_ sender: UIButton) {
        //when pressed, toggle state
        sender.isSelected.toggle()
        //if state is then true...
        if(sender.isSelected == true) {
            //change colour to green
            sender.backgroundColor = UIColor.green
            //start without drums
            if (drumLoop == false) {
                sequencer.sineSequencer.play()
                sequencer.sawSequencer.play()
                sequencer.squareSequencer.play()
                sequencer.triangleSequencer.play()
            }
            //start with drums
            if (drumLoop == true) {
                sequencer.drumPlay()
                sequencer.sineSequencer.play()
                sequencer.sawSequencer.play()
                sequencer.squareSequencer.play()
                sequencer.triangleSequencer.play()
        
            }
            
        } else {
            //change colour to grey(deselected)
            sender.backgroundColor = UIColor.darkGray
            //stop all sequencers
            sequencer.sineSequencer.stop()
            sequencer.sawSequencer.stop()
            sequencer.squareSequencer.stop()
            sequencer.triangleSequencer.stop()
            //stop drums
            sequencer.drumStop()
            //rewind sequencers so they start at correct position when played again
            sequencer.sineSequencer.rewind()
            sequencer.sawSequencer.rewind()
            sequencer.squareSequencer.rewind()
            sequencer.triangleSequencer.rewind()
        }
    }
    //no drum button action
    @IBAction func noLoop(_ sender: UIButton) {
        //set drumloop state to false
        drumLoop = false
        //forelement 7 corresponds to all loops silent
        sequencer.setLoop(forElement: 7)
    }
    
    //first house loop
    @IBAction func houseLoop(_ sender: UIButton) {
        //set drumloop state to true
        drumLoop = true
        //forelement 1 corresponds to house loop volume 1 with the rest 0
        sequencer.setLoop(forElement: 1)
    }

    @IBAction func house2Loop(_ sender: UIButton) {
        drumLoop = true
        sequencer.setLoop(forElement: 2)
    }
    
    @IBAction func house3Loop(_ sender: UIButton) {
        drumLoop = true
        sequencer.setLoop(forElement: 3)
    }
    @IBAction func technoLoop(_ sender: UIButton) {
        drumLoop = true
        sequencer.setLoop(forElement: 4)
    }
    @IBAction func garageLoop(_ sender: UIButton) {
        drumLoop = true
        sequencer.setLoop(forElement: 5)
    }
    
    @IBAction func garage2Loop(_ sender: UIButton) {
        drumLoop = true
        sequencer.setLoop(forElement: 6)
    }
    
    //volume sliders for drums and oscillators
    @IBAction func drumsVolume(_ sender: UISlider) {
        sequencer.setElementVolume(forElement: 2, toVolume: sender.value)
    }
    @IBAction func oscVolume(_ sender: UISlider) {
        sequencer.setElementVolume(forElement: 1, toVolume: sender.value)
    }
    
    //oscillator mixer
    @IBAction func sineVolume(_ sender: UISlider) {
        sequencer.setOscVolume(forElement: 1, toVolume: sender.value)
    }
    @IBAction func sawVolume(_ sender: UISlider) {
        sequencer.setOscVolume(forElement: 2, toVolume: sender.value)
    }
    
    @IBAction func squareVolume(_ sender: UISlider) {
        sequencer.setOscVolume(forElement: 3, toVolume: sender.value)
    }
    
    @IBAction func triangleVolume(_ sender: UISlider) {
        sequencer.setOscVolume(forElement: 4, toVolume: sender.value)
    }
    
    //ADSR envelopes change action for each of the oscillators
    @IBAction func setOscAttack(_ sender: UISlider) {
        sequencer.sineOscillator.attackDuration = Double(sender.value)
        sequencer.sawOscillator.attackDuration = Double(sender.value)
        sequencer.triangleOscillator.attackDuration = Double(sender.value)
        sequencer.squareOscillator.attackDuration = Double(sender.value)
    }
    @IBAction func setOscDecay(_ sender: UISlider) {
        sequencer.sineOscillator.decayDuration = Double(sender.value)
        sequencer.sawOscillator.decayDuration = Double(sender.value)
        sequencer.triangleOscillator.decayDuration = Double(sender.value)
        sequencer.squareOscillator.decayDuration = Double(sender.value)
    }
    @IBAction func setOscSustain(_ sender: UISlider) {
        sequencer.sineOscillator.sustainLevel = Double(sender.value)
        sequencer.sawOscillator.sustainLevel = Double(sender.value)
        sequencer.triangleOscillator.sustainLevel = Double(sender.value)
        sequencer.squareOscillator.sustainLevel = Double(sender.value)
    }
    @IBAction func setOscRelease(_ sender: UISlider) {
        sequencer.sineOscillator.releaseDuration = Double(sender.value)
        sequencer.sawOscillator.releaseDuration = Double(sender.value)
        sequencer.triangleOscillator.releaseDuration = Double(sender.value)
        sequencer.squareOscillator.releaseDuration = Double(sender.value)
    }
    
    //fundamental cell action
    @IBAction func buttonPressed(_ sender: UIButton) {
        //switch statement to tell the beat array which note should be added/removed in the sequence
        switch sender.superview!.tag {
        case 1: pitch = MIDINoteNumber(30)
        case 2: pitch = MIDINoteNumber(31)
        case 3: pitch = MIDINoteNumber(32)
        case 4: pitch = MIDINoteNumber(33)
            case 5: pitch = MIDINoteNumber(34)
            case 6: pitch = MIDINoteNumber(35)
            case 7: pitch = MIDINoteNumber(36)
            case 8: pitch = MIDINoteNumber(37)
            case 9: pitch = MIDINoteNumber(38)
            case 10: pitch = MIDINoteNumber(39)
            case 11: pitch = MIDINoteNumber(40)
            case 12: pitch = MIDINoteNumber(41)
            default: pitch = MIDINoteNumber(10)
        }
        //'last' function returns char and reads string so this is a messy one line recast
        //variable that is the readout of the position of cell which is determined by the
        //last digit in its tag
        let lastInt = Int(String(String(sender.tag).last!))
        switch lastInt{
        case 1: beat = AKDuration(beats:0)
        case 2: beat = AKDuration(beats:1)
        case 3: beat = AKDuration(beats:2)
        case 4: beat = AKDuration(beats:3)
        case 5: beat = AKDuration(beats:4)
        case 6: beat = AKDuration(beats:5)
        case 7: beat = AKDuration(beats:6)
        case 8: beat = AKDuration(beats:7)
            default: beat = AKDuration(beats:1)
        }
        //toggle button selection
        sender.isSelected.toggle()
        //if button selected is enabled...
        if(sender.isSelected == true) {
            //check to see if column already occupied if it is, delete it to make way for selected
            //button
            monoEnabler(position: beat)
            //add the note to the sequencer
            sequencer.addNote(beatToAdd: beat, pitchOfBeat: pitch)
            //change button to green/enabled
            sender.backgroundColor = UIColor.green
            //update mono array
             monoCheckArray[(Int(beat.seconds))] = true

        } else {
            //delete note from sequence
            sequencer.deleteNote(beatToRemove: beat)
            //change button colour back to red as deactivated
            sender.backgroundColor = UIColor.systemRed
            //update mono array
            monoCheckArray[(Int(beat.seconds))] = false
        }
    }
    //outlets for each column of buttons (all offset by +1 didnt get time to fix)
    @IBOutlet dynamic var beat1Buttons: [UIButton]!
    @IBOutlet dynamic var beat2Buttons: [UIButton]!
    @IBOutlet dynamic var beat3Buttons: [UIButton]!
    @IBOutlet dynamic var beat4Buttons: [UIButton]!
    @IBOutlet dynamic var beat5Buttons: [UIButton]!
    @IBOutlet dynamic var beat6Buttons: [UIButton]!
    @IBOutlet dynamic var beat7Buttons: [UIButton]!
    @IBOutlet dynamic var beat8Buttons: [UIButton]!
    //outlet collection for ocsillator mixer
    @IBOutlet var oscillatorMix: [UISlider]!
    //outlet collection for adsr sliders
    @IBOutlet var synthADSR: [UISlider]!
    //outlet for playpause buttton
    @IBOutlet weak var playPause: UIButton!
    //outlet for drums volume slider
    @IBOutlet weak var drumsVolume: UISlider!
    //outlet for osc volume slider
    @IBOutlet weak var oscVolume: UISlider!
    
    //function scans given column before note is added to see if it is already populated,and turns off button and deletes note in question if it is
    func monoEnabler(position: AKDuration) {
        
        let beatPosition = Int(position.seconds)
        if(monoCheckArray[beatPosition] == true) {
            //had to do beat position plus 1 because of a late stage change to the beat position structure
            let columnNameGenerator = "beat" + String(beatPosition+1) + "Buttons"
            //turn off button & delete notes of all buttons in that column
            if let columnPicker = value(forKey: columnNameGenerator) as? [UIButton]{
            for button in columnPicker {
                if (button.backgroundColor == UIColor.green){
                    button.isSelected.toggle()
                    button.backgroundColor = UIColor.red
                    sequencer.deleteNote(beatToRemove: position)
                    //update mono array
                    monoCheckArray[beatPosition] = false
                }
            }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //change playpause button colour
        playPause.backgroundColor = UIColor.darkGray
        
        //aesthetic changes and rotation for ADSR sliders
        for slider in synthADSR {
            slider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
            slider.minimumTrackTintColor = UIColor.darkGray
            slider.maximumTrackTintColor = UIColor.lightGray
            slider.thumbTintColor = UIColor.darkGray
        }
        
        //aesthetic changes and rotation for osc mixer sliders
        for slider in oscillatorMix {
            slider.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
            slider.minimumTrackTintColor = UIColor.darkGray
            slider.maximumTrackTintColor = UIColor.lightGray
            slider.thumbTintColor = UIColor.darkGray
        }
        //aesthetic changes to drum volume slider
        drumsVolume.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        drumsVolume.minimumTrackTintColor = UIColor.darkGray
        drumsVolume.maximumTrackTintColor = UIColor.lightGray
        drumsVolume.thumbTintColor = UIColor.darkGray
        //aesthetic changes to osc volume slider
        oscVolume.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        oscVolume.minimumTrackTintColor = UIColor.darkGray
        oscVolume.maximumTrackTintColor = UIColor.lightGray
        oscVolume.thumbTintColor = UIColor.darkGray
    }
}
