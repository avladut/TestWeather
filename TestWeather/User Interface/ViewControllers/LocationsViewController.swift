//
//  LocationsViewController.swift
//  TestWeather
//
//  Created by Alex on 28/08/2019.
//  Copyright © 2019 Alex. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LocationsViewController: UIViewController {
    
    @IBOutlet weak var tblLocations: UITableView!
    let locationsListViewModel: WeatherLocationListViewModel = WeatherLocationListViewModelImpl.getInstanceWithManagedContext(CoreDataConstants.mainContext)
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.locationsListViewModel.updateSavedLocations()
    }
    
    private func bindViewModel() {
        
        locationsListViewModel.savedLocations.asObservable().bind(to: self.tblLocations.rx.items) { tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationWeatherCell.reuseIdentifier, for: indexPath) as? LocationWeatherCell else {
                return UITableViewCell()
            }
            cell.config(element)
            return cell
            
            }.disposed(by: disposeBag)
        
    }
}



