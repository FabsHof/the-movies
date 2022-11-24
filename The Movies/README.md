#  The Movies App

This file describes some core concepts of the implemented application. Difficulties and possible improvements are also highlighted.


## Getting Started

To run the application, consider the `apiKey` for OMDB is working. It can be edited in `Util/Constants.swift`. 
During development, the following context was used: 
- iOS Deployment Target: `16.0
- testing simulator device: iPhone 13 iOS 16.0
- XCode version: 14.0 beta 4

## Architecture

[ARCHITECTURE.md](./ARCHITECTURE.md) roughly describes the evolution of using the adopted MVC as architectural pattern. 

## Testing

The development process did not completely follow a TDD-process. Rather, tests were added to a prototype and functionalities were iteratively added and made more robust. There are two targets containing UI and Unit tests. Essential parts of the app are tested in an appropriate form, the rest could have been extended.

## Challenges

During development, several challenges appeared which could partly not be resolved up to now. They are described in the following and which solutions were found.

### HTTP requests using `dataTaskProvider()`

It was not possible to get this recommended version of performing HTTP-requests in combination with the Combine-framework running. Problems ocurred for unit-testing `MovieApiService` and services based thereon, as the method could not be overwritten. Now, the callback-based `dataTask()`-method is used.

```
// Previous version of doing HTTP-requests
let url: URL = ...

return session.dataTaskPublisher(for: url)
    .decode(type: (MovieModel?).self, decoder: JSONDecoder())
    .receive(on: RunLoop.main)
    .eraseToAnyPublisher()
```

### Mapping JSON-values

Mapping JSON values to the desired types did not work in the following form. This was not possible to fix within the given time. Therefore, some values are stored in the "wrong" format.

```
extension MovieModel: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        guard let year: Int = try container.decode(Int.self, forKey: .year) else {
            year = Int(self.year!)
        }
    }
}
```

### Updating UI when `@State`-variable changes

In `MovieDetailView`, `movie` should have been an `@ObservedObject`. Decoding did not work with `MovieModel` being a class, though. Therefore, **movie details are not updated in the UI** when visiting details pages. (Going back to the overview and revisiting this page helps, though).  

```
// MovieDetailView
@State var movie: MovieModel?
should be:
@ObservedObject var movie: MovieModel?
MovieModel is a struct <-> Decodable and Class don't fit.
```

### TestUtils module

Mocking classes and utils were first moved to a reusable `TestUtils`-project. Due to issues with visibilities of these classes and properties, they are currently stored side-by-side to test-cases.


## Improvements

Which improvements could have been made in the application?

### Dependency Injection

Currently, `@EnvironmentObject` is used to inject services into the app. This is done at the app root. Maybe, the usage of a 3rd-party library might have helped here.

### Settings Bundle

E.g., the `apiKey` is just included in the `Constants.swift`-file. Allowing users to edit it by theirselves, would be more helpful.

### Pagination

Currently, search results are limited to a fix number (by the API). Infinite scrolling or pagination would make sence here. 


 
