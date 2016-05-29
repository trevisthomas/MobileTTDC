import Foundation

public class NetworkAdapter {
    public static func performJsonRequest(urlString: String, json: JSON, completion:(data: NSData?, error: NSError?) -> Void){
        
        let url = NSURL(string: urlString)!
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 30)
        
        do{
            let jsonData = try NSJSONSerialization.dataWithJSONObject(json, options: .PrettyPrinted)
            
            request.HTTPMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.HTTPBody = jsonData
            
            let session = NSURLSession.sharedSession()
            
            let loadDataTask = session.dataTaskWithRequest(request){ (data, response, error) -> Void in
                if let responseError = error {
                    completion(data: nil, error: responseError)
                } else if let httpResponse = response as? NSHTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        completion(data: nil, error: createError(httpResponse.statusCode, message: "Unepxected http response code:"))
                    } else {
                        completion(data: data, error: nil)
                    }
                }
            }
            loadDataTask.resume()
            
        }
        catch {
            completion(data: nil, error: createError(-1, message: "Caught an exception trying to jasonify the json."))
        }
    }

    private static func createError(withErrorCode: Int, message: String) -> NSError{
        let statusError = NSError(domain:"us.ttdc", code: withErrorCode, userInfo:[NSLocalizedDescriptionKey : message])
        return statusError
    }
    
}