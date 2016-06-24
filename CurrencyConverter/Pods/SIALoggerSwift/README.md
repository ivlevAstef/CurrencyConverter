# SIALogger
library for simplify log and assertion

## Features

1. Five log levels:
  * Fatal
  * Error
  * Warning
  * Info
  * Trace
2. Assertion logs - in debug mode abort program, but in release mode only write message.
3. Log by condition (LogIf)
4. Configuration
5. Extensibility
6. Self log format (beginning with v1.1.0)
7. Colorful (beginning with v1.1.0)

## Install
Via CocoaPods.

### Core
`pod 'SIALogger'` Objective-C  
`pod 'SIALoggerSwift'` Swift (iOS8+) also need write in your PodFile `use_frameworks!`

### Colorful (beginning with v1.1.0)
`pod 'SIALogger/Colorful'` Objective-C.
`pod 'SIALoggerSwift/Colorful'` Swift

## Usage
#### Objective-C
```Obj-C
#import <SIALogger/SIALogger.h>

...
... {
 [SIALogConfig setOutputs:@[ [SIALogColoredConsoleOutput new] ]];
 [SIALogConfig setFormatTime: @"HH:mm:ss:SSS"];
 [SIALogConfig setMaxLogLevel: SIALogLevels.Info];

 SIALogTrace(@"message");// no print
 SIALogInfo(@"message");//print
 SIALogWarning(@"message");//print
 SIALogError(@"message");//print
  
 [SIALogConfig setMaxLogLevel: SIALogLevels.Error];
 SIALogTrace(@"message");// no print
 SIALogWarning(@"message");// no print
 SIALogError(@"message");//print
  
 [SIALogConfig setMaxLogLevel: SIALogLevels.Trace];
 SIALogTraceIf(true, @"message");//print
  
  if (SIALogTraceIf(false, @"message")) {//no print
    SIALogInfo(@"message");//no print
  }
  
  if (SIALogInfoIf(true, @"message")) {//print
    SIALogInfo(@"message");//print
  }
  
  SIALogAssertMsg(false, @"assert");//print, and abort debug
  SIALogFatal(@"message");//print, and always abort
}

```
#### Swift
```Swift
import SIALogger

...
... {
 SIALogConfig.outputs = [ SIALogColoredConsoleOutput() ]
 SIALogConfig.formatTime = "HH:mm:ss:SSS"
 SIALogConfig.maxLogLevel = SIALogLevel.Info

 SIALog.Trace("message") // no print
 SIALog.Info("message") //print
 SIALog.Warning("message") //print
 SIALog.Error("message") //print
  
 SIALogConfig.maxLogLevel = SIALogLevel.Error
 SIALog.Trace("message") // no print
 SIALog.Warning("message") // no print
 SIALog.Error("message") //print
  
 SIALogConfig.maxLogLevel = SIALogLevel.Trace
 SIALog.TraceIf(true, msg: "message") //print
  
  if SIALogTraceIf(false, msg: "message" {//no print
    SIALogInfo("message")//no print
  }
  
  if SIALogInfoIf(true, msg: "message") {//print
    SIALogInfo("message") //print
  }
  
  SIALog.Assert(false, msg: "assert") //print, and abort debug
  SIALog.Fatal("message") //print, and always abort
}
```

## Result
![log example](https://cloud.githubusercontent.com/assets/5517599/15848089/800436b6-2cac-11e6-8144-e137a9db9ab2.png)

## Documentation
#### v1.1.X
Objective-C documentation can be found at [SIALogger Objective-C](https://github.com/ivlevAstef/SIALogger/wiki/SIALogger-Objective-C_v110)  
Swift documentation can be found at [SIALogger Swift](https://github.com/ivlevAstef/SIALogger/wiki/SIALogger-Swift_v110)

#### v1.0.0
Objective-C documentation can be found at [SIALogger Objective-C](https://github.com/ivlevAstef/SIALogger/wiki/SIALogger-Objective-C)  
Swift documentation can be found at [SIALogger Swift](https://github.com/ivlevAstef/SIALogger/wiki/SIALogger-Swift)

## Requirements
* Objective-C - iOS 5.0+; ARC; Xcode 5.0
* Swift - iOS 8.0+; ARC; Xcode 7.0

## Third Party Tools That Work With XCGLogger
* [XcodeColors](https://github.com/robbiehanson/XcodeColors): Enable colour in the Xcode console 
* [KZLinkedConsole](https://github.com/krzysztofzablocki/KZLinkedConsole): Link from a log line directly to the code that produced it 

# Changelog
See [CHANGELOG.md](https://github.com/ivlevAstef/SIALogger/blob/master/CHANGELOG.md) file.
