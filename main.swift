//
//  main.swift
//  mytool
//
//  Created by Takashi F on 6/6/15.
//  Copyright (c) 2015 Takashi F. All rights reserved.
//

import Foundation

// https://github.com/kareman/SwiftShell
import SwiftShell // a lib to run external shell commands.

    // list of git repositories ["a repo name", "a branch name"]
    let repos = [
        ["MyBeacon", "master"],
        ["MyMap",    "branch1"]
    ]

    // callback: process each repo
    // 1. git clone 
    // 2. git checkout
    // 3. mvn ...
    func worker(r: [String]) -> ()
    {
        var command: String? = nil
        
        if !File.fileExistsAtPath("\(r[0])")
        {
            command =
                "git clone https://github.com/tfutada/\(r[0]).git" +
                " ; cd \(r[0])" +
                " ; git checkout \(r[1])" +
                " ; mvn package; "
        } else {
            command =
                "cd \(r[0])" +
                " ; git checkout \(r[1])" +
                " ; git pull --quiet" +
                " ; mvn package; "
        }
        
        run(command!) |>> standardoutput // invokes the external shell.
    }

// 
// Main
//

for r in repos
{
    let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
    // fork a thread to process each repo.
    dispatch_async(queue) {
        worker(r)
    }
}

// Check if the threads, shells, are running.

//if run("ps") |> run("grep mvn").read().isEmpty()
//{
//    wait()
// else
//    exit()
//}












