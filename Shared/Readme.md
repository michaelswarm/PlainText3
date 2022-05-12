#  PlainText3
PlainText3 is most advanced PlainText app. (Mar 2022, Xcode 13, SwiftUI 3, MacOS 12, IOS 15)
Most advanced document app. 
Both IOS and Mac. (Uses both unique files: MenuCommandsOS and ContentViewOS, and preprocessor conditionals #if os(OX).)

# Key Text Features
Find-Replace
Print
Status Bottom Bar
Inspector Side Bar
This is above and beyond basic SwiftUI TextEditor. 

# Minor Features
App Icons and Accent Color from Swift Playgrounds.

# Custom SwiftUI Elements
Use custom split view (CustomHSplitView). (Should Mac use Mac's own HSplitView?)

# TBD SwiftUI Elements
Use custom SwiftUI elements from DesignElements, including InspectorLayout (used in TextCountView.)
Try custom tab view from DesignElements???

# Custom Extensions
StringExtensions
NLStringExtensions
AttributedStringExtensions
FocusedValueExtensions (Seems bugs with focused value API.)

# TBD Custom Extensions
Try custom logging. Test and measure use of NL features. 


# Misc
PlainTextApp

Basic architecture (top down) of a document based SwiftUI app. 

PlainTextApp
1. DocumentGroup scene with new document.
2. Document value binding (content model and storage) passed to ContentView.
3. Main model shared object passed to commands (menus) and set in environment (views).

MenuCommandsIOS
MenuCommandsMac

CustomHSplitView
- Use CustomHSplitView for sidebar. 
- Just use HSplitView on Mac?
- Adds show-hide sidebar toolbar button. 

Extra Stuff
- Document id and content view state tracking. 
- FocusedValue and focusedSceneValue to pass document to menu. Bug: Causes crash. 

# FYI
https://coteditor.com
Good basic Mac editor. Main use code editor. Nice preferences options for canvas, status bar, etc. 
