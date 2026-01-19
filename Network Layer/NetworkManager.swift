//
//  APIConfig.swift
//  FakeStore
//
//  Created by Dawood on 19/01/2026.
//
import Foundation

enum APIConfig {
    static let baseURL = "https://fakestoreapi.com"
    static let timeout: TimeInterval = 30
    
    enum Environment {
        case production
        case staging
        
        var baseURL: String {
            switch self {
            case .production:
                return "https://fakestoreapi.com"
            case .staging:
                return "https://staging.fakestoreapi.com"
            }
        }
    }
    
    static let environment: Environment = .production
}

// MARK: - 2. HTTP Method

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "Delete"
}

// MARK: - 3. EndPoint Protocol (Generic)

protocol Endpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
}

extension Endpoint {
    var baseURL: String {
        APIConfig.baseURL
    }
    
    var url: URL? {
        var componenets = URLComponents(string: baseURL + path)
        componenets?.queryItems = queryItems
        return componenets?.url
    }
    
    var headers: [String: String]? {
        ["Content-Type": "application/json"]
    }
    
    var queryItems: [URLQueryItem]? {
        nil
    }
    
    var body: Data? {
        nil
    }
}

// MARK: - 4. FakeStore API Endpoints

enum FakeStoreEndpoint: Endpoint {
    
    
    // MARK: Products
    case getAllProducts
    case getProduct(id: Int)
    case getProductsByCategory(category: String)
    case getCategories
    case createProduct(request: ProductRequest)
    case updateProduct(id: Int, request: ProductRequest)
    case deleteProduct(id: Int)
    
    
    // MARK: - Carts
    case getAllCarts
    case getCart(id: Int)
    case getUserCarts(userId: Int)
    case createCart(request: CartRequest)
    case updateCart(id: Int, request: CartRequest)
    case deleteCart(id: Int)
    
    // MARK: - Users
    case getAllUsers
    case getUser(id: Int)
    case createUser(request: UserRequest)
    case updateUser(id: Int, request: UserRequest)
    case deleteUser(id: Int)
    
    // MARK: - Auth
    case login(request: LoginRequest)
    
    var path: String {
        switch self {
        case .getAllProducts:
            return "/products"
        case .getProduct(let id):
            return "/products/\(id)"
        case .getProductsByCategory(let category):
            return "/products/category/\(category)"
        case .getCategories:
            return "products/categories"
        case .createProduct:
            return "/products"
        case .updateProduct(let id, _):
            return "/products/\(id)"
        case .deleteProduct(let id):
            return "/products/\(id)"
            
            // Carts
        case .getAllCarts:
            return "/carts"
        case .getCart(let id):
            return "/carts/\(id)"
        case .getUserCarts(let userId):
            return "/carts/user/\(userId)"
        case .createCart:
            return "/carts"
        case .updateCart(let id, _):
            return "/carts/\(id)"
        case .deleteCart(let id):
            return "/carts/\(id)"
            
            // Users
        case .getAllUsers:
            return "/users"
        case .getUser(let id):
            return "/users/\(id)"
        case .createUser:
            return "/users"
        case .updateUser(let id, _):
            return "/users/\(id)"
        case .deleteUser(let id):
            return "/users/\(id)"
            
            // Auth
        case .login:
            return "/auth/login"
            
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getAllProducts, .getProduct, .getProductsByCategory, .getCategories,
                .getAllCarts, .getCart, .getUserCarts,
                .getAllUsers, .getUser:
            return .get
            
        case .createProduct, .createCart, .createUser, .login:
            return .post
            
        case .updateProduct, .updateCart, .updateUser:
            return .put
            
        case .deleteProduct, .deleteCart, .deleteUser:
            return .delete
        }
    }
    
    // MARK: Body
    
    var body: Data? {
        switch self {
        case .createProduct(let request), .updateProduct(_, let request):
            return try? JSONEncoder().encode(request)
            
        case .createCart(let request), .updateCart(_, let request):
            return try? JSONEncoder().encode(request)
            
        case .createUser(let request), .updateUser(_, let request):
            return try? JSONEncoder().encode(request)
            
        case .login(let request):
            return try? JSONEncoder().encode(request)
            
        default:
            return nil
        }
    }
}


