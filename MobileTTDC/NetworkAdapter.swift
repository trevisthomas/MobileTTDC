import Foundation

class NetworkAdapter {
    
    static func performCommand<R>(_ urlString: String, command: Command, completion: @escaping (_ response: R?, _ error: String?)->Void) where R: Response{
        
        NetworkAdapter.performJsonRequest(urlString, json: command.toJSON()!, completion:{(data, error) -> Void in
            //Jump to UI thread to send response
            func completeOnUiThread(response: R?, error: String?){
                DispatchQueue.main.async {
                    completion(response, error)
                }
            }
            
            if let data = data {
                var json: [String: AnyObject]!
                do {
                    json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions()) as? [String: AnyObject]
                } catch {
                    completeOnUiThread(response: nil, error: "Failed to parse json request.")
                    return
                }
                
                if let _ = command.transactionId{
                    //Sigh.  Due to the value type implentation i couldnt call a simple setter.  So i just stuff the id into the json.
                    json["transactionId"] = command.transactionId as AnyObject?
                }
                
                guard let decodableResponse = R(json: json) else {
                    completeOnUiThread(response: nil, error: "Failed to parse json response.")
                    return;
                }
                
                
                
                completeOnUiThread(response: decodableResponse, error: nil)
            } else if let error = error {
                completeOnUiThread(response: nil, error: error.localizedDescription)
            }
            else {
                completeOnUiThread(response: nil, error: nil)
            }
            
        })
    }

    public static func getUrlSession() -> URLSession {
        return URLSession(
            configuration: URLSessionConfiguration.ephemeral,
            delegate: NSURLSessionPinningDelegate(),
            delegateQueue: nil)
    }
    
    fileprivate static func performJsonRequest(_ urlString: String, json: JSON, completion:@escaping ( _ data: Data?, _ error: Error?) -> Void){
        
        let url = URL(string: urlString)!
        
        var request = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 30) as URLRequest
        
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            
            request.httpMethod = "POST"
            request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            
//            let session = URLSession.shared
            
            let session = getUrlSession()
            
            
            let loadDataTask = session.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
                if let responseError = error {
                    completion(nil, responseError)
                } else if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode == 200{
                        completion(data, nil)
                    }
                    else if httpResponse.statusCode == 202{
                        //Do nothing?
                        completion(nil, nil)
                    }
                    else {
                        completion( nil, createError(httpResponse.statusCode, message: "Unepxected http response code:"))
                        
                    }
                }
            })
            loadDataTask.resume()
            
        }
        catch {
            completion(nil, createError(-1, message: "Caught an exception trying to jasonify the json."))
        }
    }

    fileprivate static func createError(_ withErrorCode: Int, message: String) -> NSError{
        let statusError = NSError(domain:"us.ttdc", code: withErrorCode, userInfo:[NSLocalizedDescriptionKey : message])
        return statusError
    }
    
}
