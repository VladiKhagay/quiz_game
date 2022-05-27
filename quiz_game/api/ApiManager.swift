import Foundation

let BASE_URL = "https://api.jsonbin.io/b/628d2b2405f31f68b3a5832e/1"


class ApiManager {
    
    
    func performRequest(comp: @escaping([Question])->()){
        if let url: URL = URL(string: BASE_URL) {
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, repsonse, error) in
                
                if (error != nil){
                    print("error: \(String(describing: error))")
                    return
                }
                
                do {
                    let result  = try JSONDecoder().decode([Question].self, from: data!)
                    comp(result)
                } catch {
                    
                    print("error: \(Error.self)")
                }
                
                
            }
            
            task.resume()
        }
        
    }
    
    
}
