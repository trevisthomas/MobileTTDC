import Foundation

class NetworkAdapter {
    
    static func performCommand<R where R: Response>(urlString: String, command: Command, completion: (response: R?, error: String?)->Void){
        
        NetworkAdapter.performJsonRequest(urlString, json: command.toJSON()!, completion:{(data, error) -> Void in
            //Jump to UI thread to send response
            func completeOnUiThread(response response: R?, error: String?){
                dispatch_async(dispatch_get_main_queue()) {
                    completion(response: response, error: error)
                }
            }
            
            if let data = data {
                var json: [String: AnyObject]!
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [String: AnyObject]
                } catch {
                    completeOnUiThread(response: nil, error: "Failed to parse json request.")
                    return
                }
                
                if let _ = command.transactionId{
                    //Sigh.  Due to the value type implentation i couldnt call a simple setter.  So i just stuff the id into the json.
                    json["transactionId"] = command.transactionId
                }
                
                guard let decodableResponse = R(json: json) else {
                    completeOnUiThread(response: nil, error: "Failed to parse json response.")
                    return;
                }
                
                
                
                completeOnUiThread(response: decodableResponse, error: nil)
            } else if let error = error {
                completeOnUiThread(response: nil, error: error.description)
            }
            else {
                completeOnUiThread(response: nil, error: nil)
            }
            
        })
    }

    
    private static func performJsonRequest(urlString: String, json: JSON, completion:(data: NSData?, error: NSError?) -> Void){
        
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
                    if httpResponse.statusCode == 200{
                        completion(data: data, error: nil)
                    }
                    else if httpResponse.statusCode == 202{
                        //Do nothing?
                        completion(data: nil, error: nil)
                    }
                    else {
                        completion(data: nil, error: createError(httpResponse.statusCode, message: "Unepxected http response code:"))
                        
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