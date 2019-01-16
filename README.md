# SideEffects
A µFramework for handling side effects in a Redux [ReSwift](https://www.github.com/ReSwift/ReSwift) applcation.

There are a lot of ways to manage side effects in a Redux application. Anything from using Thunks, Sagas, Observables and more. This is a different take on it from the normal approaches that plays to Swift's strengths, while taking inspiration from [redux-observables](https://github.com/redux-observable/redux-observable) and [ngrx effects](https://github.com/ngrx/effects) but without the `rx` part. The goal of `SideEffect`s is to allow you to easiliy, and declaritivly define something that happens anytime an `Action` is dispatched. Allowing your views to dispatch vanilla Redux actions and be completely agnostic to any side effects. They are effectively a mini middleware.

## Usage
For example if you have an action `ItemSelected` that is dispatch when ever an item is selected from a list.
When its fired you might want to call an API to load the record from the database.
```swift
SideEffect(of: ItemSelected.self) { action, state, dispatch in
    api.loadRecord(id: action.id) { response
        // using the dispatch function you can dispatch a success/failure action.
    }
}
```
There can also be multiple `SideEffect`s defined per action. So to coninute on the previous example, if you also wanted to display the item's view controller as well. I could define another `SideEffect` to do so.
```swift
SideEffect(of: ItemSelected.self) { action, state, dispatch in
    dispatch(SetRouteAction(...))
}
```

## Setup
Firstly, for ease of use first create a typealias for your application state's SideEffects.
```swift
typealias SideEffect = Store<AppState>.SideEffect
```
Then define your applications SideEffects. The amount of SideEffects in the application can add up quick. For ease of organization it is recommended to separate them into multiple lists like so:
```swift
let mySideEffects: [SideEffect] = [
    SideEffect(of: ItemSelected.self) { ... },
    SideEffect(of: AnotherAction.self) { ... },
]
```
Then create the middleware and add it to the `store`
```swift
createSideEffectMiddleware(effects: mySideEffects + moreSideEffects)
```
And thats it! 🎉

## Installation
### Carthage
You can install SideEffects via Carthage by adding the following line to your `Cartfile`:
```
github "wickwirew/SideEffects"
```
### CocoaPods

You can install SideEffects via CocoaPods by adding the following line to your `Podfile`:
```
pod 'SideEffects'
```
