# ViewPlaceholder

UITableView and UICollectionView placeholders for states like **no internet connection**, **no data**, **loading** written in Swift.
Is easy to implement, just drag and drom into your project.

## Getting Started

Download repository and run on the simulator. Application simulate network requests with different responses.
Refresh for simulate requests.

### Installing

1. Open project

2. Drag and drop **ViewPlaceholder** folder into your project

3. Set in your code


```swift
final class FirstViewController: UIViewController {

@IBOutlet var tableview: UITableView?
	
fileprivate lazy var emptyPlaceholder = ViewPlaceholder(frame: CGRect.zero).onRetry { [weak self] in self?.refreshData() }
		
    override func viewDidLoad() {
     super.viewDidLoad()
     tableview?.backgroundView 	= emptyPlaceholder
     
     /* or
      someCollectionView.backgroundView = emptyPlaceholder
     */
     
     loadDataFromBackEnd() 
     
    }
}
```

And then, on your downloading method

```swift
extension FirstViewController {

  func loadDataFromBackEnd() {
    
    /* 
      ...
      your code here
      ...
      
      on callback from networking manager handle raspose:
      self.emptyPlaceholder.handleRespunse(status: success, total: total)
    */
    
    networking.send(.someRequest) { (success, totalItems) in
    /*
      ... your code here
    */   
     self.emptyPlaceholder.handleRespunse(status: success, total: total)
     
    }
  }

}
```

## License

Free
