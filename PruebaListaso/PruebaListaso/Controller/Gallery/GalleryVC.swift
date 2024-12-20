//
//  GalleryVC.swift
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

import Foundation
import UIKit

@objc class GalleryVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    var albums: [GalleryElement] = [] // Todos los datos
    var currentAlbums: [GalleryElement] = [] // Datos visibles
    var collectionView: UICollectionView!
    let Conection = Conections()
    var isLoading = false // Para evitar solicitudes múltiples
    var currentPage = 0 // Página actual
    let pageSize = 20 // Tamaño del lote de datos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initConfig()
        let idComment = SharedManager.sharedInstance().sharedData
        self.getAlbums(idAlbum: idComment)
    }
    
    func initConfig() {
        // Crear layout para UICollectionView
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 170, height: 130) // Tamaño de cada celda
        layout.minimumLineSpacing = 20 // Espacio entre filas
        layout.minimumInteritemSpacing = 20 // Espacio entre columnas
        layout.sectionInset = UIEdgeInsets(top: 5, left: 50, bottom: 5, right: 50) // Márgenes
        
        // Crear UICollectionView
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(GalleryCell.self, forCellWithReuseIdentifier: "GalleryCell")
        
        // Agregar la colección a la vista principal
        view.addSubview(collectionView)
    }
    
    // MARK: - UICollectionView DataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCell", for: indexPath) as! GalleryCell
        let album = self.currentAlbums[indexPath.row]
        
        // Descargar imagen solo cuando sea necesario
        Conection.downloadImage(from: album.url, for: cell) { image in
            guard let image = image else {
              //  print("Error al cargar la imagen para \(album.url)")
                cell.imageView.image = UIImage(named: "album")
                return
            }
            cell.imageView.image = image
        }
        
        // Cargar más datos si estamos en la última celda visible
        if indexPath.row == currentAlbums.count - 1 && !isLoading {
            loadMoreData()
        }
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 60) / 3 // 3 columnas con espacio entre ellas
        return CGSize(width: width, height: width) // Celdas cuadradas
    }
    
    // MARK: - WebService
    func getAlbums(idAlbum: String) {
        guard !isLoading else { return }
        isLoading = true
      //  print("Obteniendo álbumes desde el servidor...")
        
        Conection.fetchData(from: "/posts/\(idAlbum)/photos", responseType: [GalleryElement].self) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let album):
                //  print("Álbumes recibidos: \(album.count)")
                    self.albums = album
                    self.loadMoreData() // Cargar la primera página
                case .failure(let error):
                    AlertHelper.showAlert(on: self, withMessage: error.localizedDescription)
                }
            }
        }
    }
    
    func loadMoreData() {
        guard !isLoading else { return }
        isLoading = true
        print("Cargando más datos...")
        
        let start = currentPage * pageSize
        let end = min(start + pageSize, albums.count)
        guard start < end else {
            print("No hay más datos para cargar.")
            isLoading = false
            return
        }
        
        let newAlbums = Array(albums[start..<end])
        currentAlbums.append(contentsOf: newAlbums)
        currentPage += 1
        
     //   print("Nuevos datos cargados: \(newAlbums.count)")
        collectionView.reloadData()
        isLoading = false
    }
}
