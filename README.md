# Github Search

Github Search as I call it🥳, is an iOS app that utilises [Github User API](https://docs.github.com/en/rest/users/users?apiVersion=2022-11-28) to lookup users by their username.

### Framework

App is built in swift using UIKit as the UI framework and [RxSwift](https://github.com/ReactiveX/RxSwift) Package

### Installation

> Used SPM to add packages

- Clone the repo
- Open the project in xCode and build the app. if you run into package errors, resolve packages

### Architecture

The projectt architecture is built around `MVVM-C` with C being the coorindator

The coordinator handles the app flow throughtout. All coordinators shouuld inherit from `BaseCoordinator`.

The project is built to be reactive with `RxSwift` which eliminates the usage of uunnecessay delegates and NotificationCenter

The Views were programmatically written(no storyboard)

### Unit tests

In this Project, I adoptes the `TDD(Test Driven Development)` method and testiing is much more important going forward witth this project.

All viewModels were written to make them easily testable.

### Screenshots

> Coming soon...🥳
