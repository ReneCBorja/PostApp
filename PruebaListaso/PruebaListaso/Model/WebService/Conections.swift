//
//  Conections.swift
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

import Foundation

import Foundation
import Network
import UIKit

class Conections {
    private let baseURL = "https://jsonplaceholder.typicode.com"
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    let imageCache = NSCache<NSString, UIImage>()
    
    init() {
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
    
    /// Verificar si hay conexión a internet
    private func isInternetAvailable() -> Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    // MARK: - Web service config
    /// Función genérica para realizar solicitudes y decodificar la respuesta
    /// - Parameters:
    ///   - endpoint: El endpoint de la API.
    ///   - responseType: El tipo de dato esperado que conforma la respuesta.
    ///   - completion: Closure que maneja el resultado de la solicitud.
    func fetchData<T: Decodable>(from endpoint: String, responseType: T.Type, showLoading: Bool = true, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard isInternetAvailable() else {
            completion(.failure(NetworkError.noInternetConnection))
            
            return
        }
        
        if showLoading {
            showLoadingIndicator()
        }
        
        guard let url = URL(string: baseURL + endpoint) else {
            completion(.failure(NetworkError.invalidURL))
            if showLoading {
                hideLoadingIndicator()
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if showLoading {
                self.hideLoadingIndicator()
            }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.noData))
                return
            }
            
            do {
                let decodedData = try JSONDecoder().decode(responseType, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
    
    private func showLoadingIndicator() {
        DispatchQueue.main.async {
            // Obtener la escena activa
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }) else { return }
            
            let loadingView = UIActivityIndicatorView(style: .large)
            loadingView.center = window.center
            loadingView.tag = 999 // Identificar para remover después
            window.addSubview(loadingView)
            loadingView.startAnimating()
        }
    }
    
    private func hideLoadingIndicator() {
        DispatchQueue.main.async {
            // Obtener la escena activa
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let window = windowScene.windows.first(where: { $0.isKeyWindow }),
                  let loadingView = window.viewWithTag(999) as? UIActivityIndicatorView else { return }
            
            loadingView.stopAnimating()
            loadingView.removeFromSuperview()
        }
    }
    
    // MARK: - Download image
    func downloadImage(from urlString: String, for cell: GalleryCell,completion: @escaping (UIImage?) -> Void) {
        // Mostrar el indicador de carga
        DispatchQueue.main.async {
            cell.activityIndicator.startAnimating()
            cell.imageView.image = nil // Resetear la imagen previa
        }
        
        // Verificar si la imagen ya está en la caché
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.imageView.image = cachedImage
            }
            return
        }
        
        // Descargar la imagen
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
            }
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                }
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                }
                return
            }
            
            // Guardar en la caché
            self.imageCache.setObject(image, forKey: urlString as NSString)
            
            // Asignar la imagen descargada
            DispatchQueue.main.async {
                cell.activityIndicator.stopAnimating()
                cell.imageView.image = image
            }
        }
        task.resume()
    }
}

// MARK: - Errors
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case noData
    case noInternetConnection
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "La URL es inválida."
        case .invalidResponse:
            return "La respuesta del servidor no es válida."
        case .noData:
            return "No se recibió ningún dato."
        case .noInternetConnection:
            return "No hay conexión a internet."
        }
    }
}
