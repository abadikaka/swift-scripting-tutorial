import Foundation
import ArgumentParser
import TSCBasic
import TSCUtility

struct iOSScripting: ParsableCommand {
        
    @Argument(help: "Specify your directory name")
    var name: String
    
    @Argument(help: "Specify your moving directory")
    var path: String
    
    func run() throws {

        let startAnimation: PercentProgressAnimation = PercentProgressAnimation(stream: stdoutStream, header: "👾 Start to bake new directory of \(name) for moving it into \(path).... 👾")
        
        //
        let commandProcess = Process()
        let movingCommandProcess = Process()
        
        // The URL for execute the process command, default in /bin/sh
        if #available(OSX 10.13, *) {
            commandProcess.executableURL = URL(fileURLWithPath: "/bin/mkdir")
            movingCommandProcess.executableURL = URL(fileURLWithPath: "/bin/mv")
        } else {
            // Fallback on earlier versions
            commandProcess.launchPath = "/bin/mkdir"
            movingCommandProcess.launchPath = "/bin/mv"
        }
    
        // The directory name and final path
        let directoryCommand = "\(name)"
        let moveCommand = "\(path)"
        // The arguments we pass into the process object separated by array
        commandProcess.arguments = [directoryCommand]
        // The arguments we pass into the process object (take the first one as the folder we want to move and second one is the target path)
        movingCommandProcess.arguments = [directoryCommand, moveCommand]
        
        do {
            
            for i in 0..<100 {
                let second: Double = 1_000_000
                usleep(UInt32(second * 0.05))
                startAnimation.update(step: i, total: 100, text: "Running...👻")
            }
            
            if #available(OSX 10.13, *) {
                try commandProcess.run()
                try movingCommandProcess.run()
                startAnimation.complete(success: true)
                print("Success to make new directory !🤖🤖🤖")
            } else {
                // Fallback on earlier versions
                commandProcess.launch()
                movingCommandProcess.launch()
            }
        } catch {
            print("got error \(error.localizedDescription)")
        }
    }
}

iOSScripting.main()
