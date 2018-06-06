//
//  ViewController.swift
//  SpeechDetector
//
//  Created by mainvolume on 6/6/18.
//  Copyright © 2018 mainvolume. All rights reserved.
//

import TLSphinx
import AVFoundation

class ViewController: UIViewController {
    
    var decoder: TLSphinx.Decoder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decodeSpeech()
    }
    
    
    func decodeSpeech() {
        guard let modelPath = getModelPath() else {
            print("error")
            return
        }
        
        let engine = AVAudioEngine()
        let input = engine.inputNode
        
        let hmm = modelPath.appendingPathComponent("en-us")
        let lm = modelPath.appendingPathComponent("en-us.lm.dmp")
        let dict = modelPath.appendingPathComponent("cmudict-en-us.dict")
        
        
        //override feat.parameter
        guard let config = Config(args: ("-hmm", hmm), ("-lm", lm), ("-dict", dict),
                                  ("-samprate", "\(input.outputFormat(forBus: 0).sampleRate)"),
                                  ("-nfft", "\(TLSphinx.bufferSize)")) else {
                                    
            print("Error in the Config")
            return
        }
        
        config.showDebugInfo = false
        
        guard let aDecoder = Decoder(config:config) else {
            print("Error in the Decoder")
            return
        }
        
        decoder = aDecoder
        
        
        try? decoder.startDecodingSpeech { (hypothesis) in
            print( "\(String(describing: hypothesis?.text))" )
        }
    }
    
    func getModelPath() -> NSString? {
        return Bundle(for: TLSphinx.Decoder.self).path(forResource: "en-us", ofType: nil) as NSString?
        
    }
    
}
