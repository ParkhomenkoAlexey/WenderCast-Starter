

import UIKit

class PodcastFeedTableViewController: UITableViewController {
  let podcastStore = PodcastStore.sharedStore
  
  override var prefersStatusBarHidden: Bool {
    return true
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 75
    
    if let patternImage = UIImage(named: "pattern-grey") {
      let backgroundView = UIView()
      backgroundView.backgroundColor = UIColor(patternImage: patternImage)
      tableView.backgroundView = backgroundView
    }
    
    if podcastStore.items.isEmpty {
      print("Loading podcast feed for the first time")
      podcastStore.refreshItems{ didLoadNewItems in
        if didLoadNewItems {
          DispatchQueue.main.async {
            self.tableView.reloadData()
          }
        }
      }
    }
  }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension PodcastFeedTableViewController {
  override func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int {
    return podcastStore.items.count
  }
  
  override func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "PodcastItemCell",
                                             for: indexPath)
    
    if let podcastCell = cell as? PodcastItemCell {
      podcastCell.update(with: podcastStore.items[indexPath.row])
    }
    
    return cell
  }
  
  override func tableView(_ tableView: UITableView,
                          didSelectRowAt indexPath: IndexPath) {
    print(indexPath)
    let sender = PushNotificationSender()
    let token = "c9z77PUs80FsgXS5rhOaBV:APA91bFwrh1wW0bBaErnrcMunuiOecr2Z5-0yVWK8J4hc7z1lncCyxWDpksLRuOh3Bg0IKy_IZJ_R2bNt7CIkGNdrgGE2jiUN0cxjJCQwpUKE5ITb6GxWP1nH1Y6RWV59yF0YcmgkIS-"
    sender.sendPushNotification(to: token, title: "Notification title", body: "Notification body")
  }
}
