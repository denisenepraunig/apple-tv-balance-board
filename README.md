# Apple TV Balance Board
Create your own DIY balance board for AppleTV with Siri Remote.

## Why?
Several years ago I broke my leg and I trained with a balance board to get fit again. It was a good training but very boring, because of this I always wanted to create my own balance board game. The Wii balance board was a great idea, but using it was not really challenging for my muscles. It is posible to create an own [DIY Wii like balance board](http://www.instructables.com/id/Make-your-own-Balance-Board-and-be-on-your-way-to/). It would have been also very unlikely that I would be able to create a game for the Wii balance board and I heard game console dev kits are really expensive and hard to get. 

I am a Swift developer, I wanted to use a real "challenging" balance board and own an Apple TV. Siri Remote has a built-in accelerometer and gyroscope so this was the perfect solution for me. My goal was that everyone can build his own balance board with the balance board that is sufficient for you, your fitness level and your budget. I am currently working on some Apple TV games that support my DIY Apple TV Balance Board but would also be playable with only the Siri Remote. I will tweet about the progress as [@denisenepraunig](https://twitter.com/denisenepraunig) and will update this repository with information about my games.

In this repository I will provide some background information and some starter projects so that you can make your own balance board games.

## Instructions
**I assume no liabiltiy when you accidentically step onto the plastic box, hurt yourself and break the Siri Remote!**

I put my Siri Remote inside a plastic lunch box so that I don't accidentally step on it. I put some paper and cardboard inside the lunch box so that the Siri Remote doesn't move around. It is easy to open and close this kind of lunch box.

![Siri Remote inside a lunch box](pictures/siri-remote-in-a-lunchbox.jpg)

I mounted the lunch box onto the balance board with some tape. Using a velcro tape would also have been possible. You could glue the velcro tape onto the balance board and the lunch box. 

![Lunch box mounted onto the balance board with tape](pictures/lunchbox-on-balance-board.jpg)

## Starter Projects
TODO

## Technical Details
### Siri Remote
The Siri Remote has a built in accelerometer and gyroscope (source: [Apple TV technical specifications](https://support.apple.com/kb/SP724?locale=en_US)). The Siri Remote is also a game controller which supports the micro control layout, you can read more about it in the [Game Controller Programming Guide](https://developer.apple.com/library/content/documentation/ServicesDiscovery/Conceptual/GameControllerPG/IncorporatingControllersintoYourDesign/IncorporatingControllersintoYourDesign.html#//apple_ref/doc/uid/TP40013276-CH4-SW6) and watch the [WWDC talk about Siri Remote and Game Controllers](https://developer.apple.com/videos/play/techtalks-apple-tv/4/).

![reading accelerometer data from Siri Remote](pictures/siri-remote-accelerometer.jpg)

### Accessing Siri Remote Sensor Values
The sensor values from the Siri Remote can be read via a change-handler or by directly reading the values. Before reading the values the Siri Remote has to be registered as a game controller. Please refer to the Big Nerd Ranch guide [tvOS Games, Part 1: Using the Game Controller Framework](https://www.bignerdranch.com/blog/tvos-games-part-1-using-the-game-controller-framework/) for details. 

One thing I noticed when debugging in the simulator is that the Siri Remote is registered as an extended game pad. Therefore I only test my apps on real hardware.

#### Reading sensor values via Motion Handler
```swift
func registerMicroGamePadEvents(_ microGamePad: GCMicroGamepad) {

    let motionHandler: GCMotionValueChangedHandler = { (motion: GCMotion) -> () in

        print("acc:\(motion.userAcceleration)")
        print("grav:\(motion.gravity)")
        print("att:\(motion.attitude)")
        print("rot:\(motion.rotationRate)")
    }

    gamePad?.motion?.valueChangedHandler = motionHandler
}
 ```
 
 #### Reading sensor values directly
 ```swift
 if let motion = gamePad.motion {

  player.position.x += CGFloat(motion.gravity.x) * 50
  player.position.y += CGFloat(motion.gravity.y) * 50
}
```

## Why ...?
Here I want to share my thoughts on different solutions for building an own balance board.

### Why Apple TV?
I own a Mac for a couple of years and I am very happy with it (currently MBP 15") and I also own an iPhone and an iPad. In October 2016 I started my Swift iOS developer journey and I really enjoyed it. I bought an Apple TV in 2017 mainly because I saw that my favorite Yoga app was available as an Apple TV app. I really enjoyed the other native apps like Udemy, Coursera and Netflix of course. End of 2017 I wrote my first SpriteKit game for iOS and in the beginning of 2018 I wrote my first app and game for Apple TV with SpriteKit. 

As I am into the Apple ecoystem Apple TV was the logical choice for me. Siri Remote works out of the box with its accelerometer, I don't need a dedicated "dev kit" to develop an app for Apple TV and I can play my game on a big screen. No need to hook up an controller to play my game - no setup needed - Siri Remote is always connected to the Apple TV.

### Why not Arduino/Raspberry Pi/...?
My inital idea was to create the balance board with the Arduino and using some sensors. The arduino was connected to my Mac via cable. Cables suck. Should I fidget around with Bluetooth? Or send the data via WiFi? The sensor values need to be translated to some "actions" - like keyboard clicks - and how should I develop my games? Web based? Python? Do I always have to connect my Macbook to the TV? Phew... I could maybe use my phone instead - it is wireless - but stepping on a expensive phone? I need to write an app, send the data via websocket to an HTML5 game, websockets - serverside - node - hosting this - phew... Raspberry Pi - hm - Linux, Python, connecting hardware, writing games in PyGame maybe?! I am not that proficient in those things. Sure, all things are solveable, but I wanted it to be more a "software project" than a hardware hacking thing and I wanted to use my existing skills.

### Why not MFT Challenge Disc?
Back then I did not know that such a device existed - a balance board with games, but anyway, as I am a developer I wanted to make my own games and those [MFT balance boards](https://www.amazon.com/MFT-Challenge-Disc-Fitness-apparel/dp/B001V9KXCY/ref=sr_1_2?ie=UTF8&qid=1519146912&sr=8-2&keywords=mft+disc) are quite expensive. In Germany you can order a [version with bluetooth](https://www.amazon.de/MFT-Trainings-Therapieger%C3%A4t-Challenge-9005/dp/B01ENJARHE/ref=pd_sim_200_6?_encoding=UTF8&psc=1&refRID=XPPZQ1DP6JTNFASMPQ4Z) which has an app for iOS and Android.

## Link summary
* [DIY Wii like balance board](http://www.instructables.com/id/Make-your-own-Balance-Board-and-be-on-your-way-to/)
* [Apple TV technical specifications](https://support.apple.com/kb/SP724?locale=en_US)
* [Game Controller Programming Guide](https://developer.apple.com/library/content/documentation/ServicesDiscovery/Conceptual/GameControllerPG/IncorporatingControllersintoYourDesign/IncorporatingControllersintoYourDesign.html#//apple_ref/doc/uid/TP40013276-CH4-SW6)
* [WWDC talk about Siri Remote and Game Controllers](https://developer.apple.com/videos/play/techtalks-apple-tv/4/)
* [tvOS Games, Part 1: Using the Game Controller Framework](https://www.bignerdranch.com/blog/tvos-games-part-1-using-the-game-controller-framework/)
* [MFT Challange disc](https://www.amazon.com/MFT-Challenge-Disc-Fitness-apparel/dp/B001V9KXCY/ref=sr_1_2?ie=UTF8&qid=1519146912&sr=8-2&keywords=mft+disc)
