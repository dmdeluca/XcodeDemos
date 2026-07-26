//
//  ContentView.swift
//  BlockConventions
//
//  Created by David DeLuca on 7/26/26.
//

import SwiftUI
import Foundation

// 1. THIN REPRESENTATION
// A global function that captures nothing.
func globalThinFunction() {
    print("Thin")
}

// 2. THICK REPRESENTATION
// A closure that captures a local variable, triggering a heap box context.
func makeThickFunction() -> () -> Void {
    var counter = 0
    return {
        counter += 1 // Captures and mutates counter, forcing a thick context pointer
        print("Thick: \(counter)")
    }
}

// 3. BLOCK REPRESENTATION
// An Objective-C block wrapper around a closure.
let objcBlock: @convention(block) () -> Void = {
    print("Block")
}


struct ContentView: View {

  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundStyle(.tint)
      Text("Hello, world!")
      Button("Execute closures") {
        // --- EXECUTION & DEBUGGING DRIVER ---

        print("--- 1. Testing Thin ---")
        let thinRef = globalThinFunction
        thinRef()
        // DEBUGGER: Set a breakpoint on the line below.
        // Run 'v thinRef' or 'po thinRef' in the LLDB console.
        // You will see it listed as a raw function pointer (e.g., (Function) thinRef = 0x0000000100003cb0).
        print(type(of: thinRef))

        print("\n--- 2. Testing Thick ---")
        let thickRef = makeThickFunction()
        thickRef()
        // DEBUGGER: Set a breakpoint on the line below.
        // Run 'v thickRef' or 'frame variable thickRef' in LLDB.
        // You will see a data structure containing two components: a function pointer and a context pointer.
        print(type(of: thickRef))

        print("\n--- 3. Testing Block ---")
        // DEBUGGER: Set a breakpoint on the line below.
        // Run 'v objcBlock' in LLDB.
        // You will see it listed explicitly as a __NSGlobalBlock__ or __NSStackBlock__, which matches the Objective-C runtime layout.
        objcBlock()
        print(type(of: objcBlock))
      }
    }
    .padding()
  }
}

#Preview {
  ContentView()
}
