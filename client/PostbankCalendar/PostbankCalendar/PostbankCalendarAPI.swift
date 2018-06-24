import Foundation
import Alamofire
import AlamofireObjectMapper
import SwiftyUserDefaults
import ObjectMapper

class PostbankAPI {
    private var sessionManager: SessionManager
    
    enum APIConstants {
        static let baseURLString = "http://postbank-calendar"
    }
    
    private init() {
        
        let configuration = URLSessionConfiguration.default
        
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        sessionManager = SessionManager(configuration: configuration)
        
    }
    
    class var sharedInstance: PostbankAPI {
        struct Static {
            static let instance: PostbankAPI = PostbankAPI()
        }
        
        return Static.instance
    }
    
    func getAllEventsBy(year clientYear: Int, month clientMonth: Int, completionHandler: @escaping (DataResponse<ResultModel>) -> Void) {
        let req = sessionManager.request(PostbankCalendarRouter.getAllEventsByYearAndMonth(year: clientYear, month: clientMonth))
            .validate()
            .responseObject { (dataResponse: DataResponse<ResultModel>) in
                completionHandler(dataResponse)
        }
        
        print(req.debugDescription)
    }
   
    private enum PostbankCalendarRouter: URLRequestConvertible {
        case getAllEventsByYearAndMonth(year: Int, month: Int)
        case addEvent(id: Int, parameters: [Parameters])
       
        var path: String {
            switch self {
            case .getAllEventsByYearAndMonth(let year, let month):
                return "/event/list/\(year)/\(month)"
            case .addEvent(let id, let parameters):
                print("adding event")
                return "/event/add"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .addEvent:
                return .post
            default:
                return .get
            }
        }
        
        static let baseURLString = APIConstants.baseURLString
        
        func asURLRequest() throws -> URLRequest {
            let url = try PostbankCalendarRouter.baseURLString.asURL()
            var urlRequest = URLRequest(url: url.appendingPathComponent(path))
            urlRequest.httpMethod = method.rawValue
            return urlRequest
        }
        
    }
}
