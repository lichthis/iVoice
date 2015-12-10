//
//  ViewController.swift
//  iVoice
//
//  Created by lich on 15/8/12.
//  Copyright (c) 2015年 Lich. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    
    var currentPath : String!
    
    @IBOutlet weak var voiceList: NSComboBox!
    
    @IBOutlet weak var fileName: NSTextField!
    
    
    @IBOutlet weak var content: NSTextField!
    
    @IBOutlet weak var cleanBtn: NSButton!
    
    @IBOutlet weak var saveBtn: NSButton!
    
    
    @IBAction func save(sender: NSButton) {
        let fileName = self.fileName.stringValue
        let outPath = NSString(format: "-o %@.aac",fileName)
        let voice = NSString(format: "-v %@",voiceList.objectValueOfSelectedItem as! String)
        shell("/usr/bin/env",arguments: ["say",outPath,content.stringValue])
        self.content.stringValue = ""
        setFileName()
    }
    
    @IBAction func clean(sender: NSButton) {
        self.content.stringValue = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPath = "~/Documents"
        shell("/usr/bin/env",arguments: ["mkdir","iVoice"])
        currentPath = "~/Documents/iVoice"
        setFileName()
        voiceList.selectItemAtIndex(0)
        // Do any additional setup after loading the view.
    }
    
    override var representedObject: AnyObject? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    
    func setFileName()
    {
        let dateformatter = NSDateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd_hh:mm:ss_"
        let name:String  = dateformatter.stringFromDate(NSDate())
        self.fileName.stringValue = name.substringToIndex(name.startIndex.advancedBy(19));
    }
    
    func shell(launchPath: String, arguments: [AnyObject]) -> String
    {
        let task = NSTask()
        task.launchPath = launchPath
        task.arguments = arguments
        task.currentDirectoryPath = currentPath
        
        let pipe = NSPipe()
        task.standardOutput = pipe
        task.launch()
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output: String = NSString(data: data, encoding: NSUTF8StringEncoding)! as String
        if output.characters.count > 0 {
            return output.substringToIndex(output.endIndex.advancedBy(-1))
        }
        return output
    }
    
    func bash(command: String, arguments: [AnyObject]) -> String {
        let whichPathForCommand = shell("/bin/bash", arguments: [ "-l", "-c", "which \(command)" ])
        return shell(whichPathForCommand, arguments: arguments)
    }
    

}

