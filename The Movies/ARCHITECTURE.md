#  Architecture

This roughly describes, why certain decissions were made concerning the app architecture. (And was somehow a little assistance for myself).

## Clean Architecture and MVVM

In the beginning, the app followed the clean architecture principles  [https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) in combination with the MVVM-pattern  [https://www.objc.io/issues/13-architecture/mvvm/](https://www.objc.io/issues/13-architecture/mvvm/), containing the three layers

1. Presentation: holding views and their corresponding view models, which interact with the below domain-layer.
2. Domain: holding the app business logic, formed by use cases as well as system logic (data repositories).
3. Data: contains data sources and services.

## No more MVVM

As MVVM and SwiftUI do not seem to fit concerning their data flow (as e.g. state management differs [https://medium.com/@karamage/stop-using-mvvm-with-swiftui-2c46eb2cc8dc](https://medium.com/@karamage/stop-using-mvvm-with-swiftui-2c46eb2cc8dc)), MVVM seemed not to fit anymore.

```
- old (UIKit) way with MVVM:
    View <-> ViewModel <-> Model
        Binding

- new SwiftUI way: 
    SwiftUI.View <-> Model
                Binding
```

## Stores: Replacing ViewControllers with Stores

The final architecture still follows clean architecture principles and is more like a MVC-pattern. Controllers are replaced by store-components, leading to a data-flow like so:
```
View <-> Store <-> Model
```







