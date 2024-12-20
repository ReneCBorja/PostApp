//
//  SearchBar.swift
//  PruebaListaso
//
//  Created by Rene B on 12/19/24.
//

import UIKit

class SearchBarView: UIView {

    // MARK: - UI Elements
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Buscar..."
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    // MARK: - Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    // MARK: - Setup
    private func setupView() {
        backgroundColor = UIColor(named: "userBlue") // Color de fondo de la vista
        addSubview(searchBar)

        // Configuración de las restricciones para centrar y ajustar el tamaño de la barra de búsqueda
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: trailingAnchor),
            searchBar.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
