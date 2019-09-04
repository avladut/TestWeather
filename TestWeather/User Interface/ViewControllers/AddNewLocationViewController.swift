//
//  AddNewLocationViewController.swift
//  TestWeather
//
//  Created by Alex on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class AddNewLocationViewController: UIViewController {

    @IBOutlet weak var tblSearchResults: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var searchBar: UISearchBar { return searchController.searchBar }
    
    
    let locationsListViewModel: SearchLocationsViewModel = SearchLocationsViewModelImpl()
    private let disposeBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupCellTapHandling()
        configureSearchController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func bindViewModel() {
        
        locationsListViewModel.searchLocationsResult.asObservable().bind(to: self.tblSearchResults.rx.items) { tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationCell.reuseIdentifier, for: indexPath) as? LocationCell else {
                return UITableViewCell()
            }
            cell.config(element)
            return cell
            
            }.disposed(by: disposeBag)
        
    }
    
    private func setupCellTapHandling() {
        tblSearchResults.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                do {
                    try self?.locationsListViewModel.selectLocationAtIndex(index: indexPath.row)
                } catch let error {
                    ErrorHandler.showSimpleErrorAlertOnController(self, error: error)
                    return
                }
                
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
                
            }).disposed(by: disposeBag)
    }
    
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Enter Location name"
        tblSearchResults.tableHeaderView = searchController.searchBar
        definesPresentationContext = true
        
        searchBar
            .rx.text
            .orEmpty
            .throttle(.milliseconds(1500), scheduler: MainScheduler.instance)
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            .subscribe(onNext: { [unowned self] query in
                if let searchString = self.searchBar.text, searchString.count > 2 {
                    
                }
                self.locationsListViewModel.searchString.accept(query)
            })
            .disposed(by: disposeBag)
    }

}
