//
//  ActorListViewController.swift
//  ActorList
//
//  Created by Aleksandr Bolotov on 29.05.2022.
//

import UIKit

class ActorTableViewController: UIViewController {
    var tableView: ActorListViewModel!

    @IBOutlet weak var actorTableView: UITableView! {
        didSet {
            actorTableView.dataSource = self
            actorTableView.delegate = self
            actorTableView.register(ActorTableViewCell.nib, forCellReuseIdentifier: ActorTableViewCell.identifier)
        }
    }

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
            searchBar.searchTextField.delegate = self
        }
    }

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.startAnimating()
            activityIndicator.hidesWhenStopped = true
        }
    }

    @IBOutlet weak var notFoundLabel: UILabel! {
        didSet {
            notFoundLabel.isHidden = true
        }
    }

    @IBAction func logout() {
        UserService.shared.logout()
        toAuthScreen()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView = ActorListViewModel()
        bindData()
        tableView.fetchActorList()
    }

    private func bindData() {
        tableView.filteredActors.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.showData()
            }
        }
    }

    private func setupNavigationBar() {
        navigationItem.titleView = searchBar
        navigationItem.setHidesBackButton(true, animated: false)
        let logoutButton = UIBarButtonItem(image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), style: .done, target: self, action: #selector(logout))
        navigationItem.rightBarButtonItem = logoutButton
    }

    private func toAuthScreen() {
        let transition = BackNavigationTransition()
        navigationController?.view.layer.add(transition, forKey: kCATransition)

        if navigationController?.topViewController is AuthViewController {
            navigationController?.popToRootViewController(animated: true)
        } else {
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            guard let authViewController = storyboard.instantiateViewController(withIdentifier: "AuthViewController") as? AuthViewController else { return  }
            navigationController?.setViewControllers([authViewController], animated: true)
        }
    }

    private func showData() {
        activityIndicator.stopAnimating()
        actorTableView.reloadData()
    }
}

// MARK: Implements UITableViewDataSource
extension ActorTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActorTableViewCell.identifier, for: indexPath) as! ActorTableViewCell
        cell.configure(for: tableView.filteredActors.value[indexPath.row])
        return cell
    }
}

// MARK: Implements UITableViewDelegate
extension ActorTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let actorId = tableView.filteredActors.value[indexPath.row].charid
        let storyboard = UIStoryboard(name: "ActorInfo", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "ActorInfo", creator: { coder in
            ActorInfoViewController.init(actorId: actorId, coder: coder)
        })
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: Implements UISearchBarDelegate
extension ActorTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.filter(by: searchText)
        notFoundLabel.isHidden = !viewModel.filterIsEmpty
        actorTableView.reloadData()
    }

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.searchTextField.text = ""
        searchBar.resignFirstResponder()
        tableView.reset()
        notFoundLabel.isHidden = !viewModel.filterIsEmpty
        actorTableView.reloadData()
    }
}

// MARK: Implements UITextFieldDelegate
extension ActorTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchBar.showsCancelButton = false
        return true
    }
}
