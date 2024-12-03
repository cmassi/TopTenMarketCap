# TopTenMarketCap (v. 1.0.8)

### App Description

The app connect to CoinGecko server using demo API 3, and shows a list of the top ten cryptos market cap (image, name, current value)

The detail page shows a list of historical market prices data in the last week, plus latest value
There is also a small up/down arrow which provide quick info about earnings in the last week

In Detail page there is also the website link for crypto and a WebView with html description, when available.



### How to build and run project

To build/test the project has been used Xcode 16.1 (16B40) on a MacBookPro with 2,6 GHz Intel Core i7 6 core, running macOS Sonoma 14.6.1 (23G93). 

English is the preferred language, but the app is localized in Italian language too.

The app has been developed/tested on iPhone 11 device and iPhone 16 Pro Max Simulator running iOS 18.1.

It is recommended to use a real device, if you are interested in checking network availability, with messages shown in bottom line, because the Apple NWPathMonitor might have unpredictable behaviours on Simulators.


### Description of TopTenMarketCap app architecture

The app is implemented following MVVM architecture, as a SwiftUI (dark/light) app.

Previews for both Views are available in Xcode.

There are also XCTests for networking and data layer.

Has been added a Coordinator to optionally navigate via NavigationPath (e.g: push/pop on stack)


### Dependencies used

There are no package dependencies