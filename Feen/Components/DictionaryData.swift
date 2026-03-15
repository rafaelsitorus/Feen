import Foundation

let dictsData: [Dictionaries] = {
    guard let url = Bundle.main.url(forResource: "dicts_terms", withExtension: "json"),
          let data = try? Data(contentsOf: url),
          let decoded = try? JSONDecoder().decode([Dictionaries].self, from: data)
    else {
        return []
    }
    return decoded
}()
