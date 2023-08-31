//
//  AppDelegate.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 25.08.2023.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		UINavigationBar.appearance().tintColor = .primary
		UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.primary]
		
		// Эта штука нужна для того, чтобы при первом запуске приложения, когда первый раз будет показываться UIActivityViewController, это не занимало 4-5 секунд
		let lagfreeAVC: UIActivityViewController = UIActivityViewController(activityItems:  ["start"], applicationActivities: nil)
		lagfreeAVC.becomeFirstResponder()
		lagfreeAVC.resignFirstResponder()
		
		return true
	}
	
	// MARK: - Core Data stack
	
	lazy var persistentContainer: NSPersistentContainer = {
		let container = NSPersistentContainer(name: "AVAdvertisementInfo")
		container.loadPersistentStores(completionHandler: { (storeDescription, error) in
			if let error = error as NSError? {
				fatalError("Unresolved error \(error), \(error.userInfo)")
			}
		})
		return container
	}()
	
	// MARK: - Core Data Saving support
	
	func saveContext () {
		let context = persistentContainer.viewContext
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				let nserror = error as NSError
				fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
			}
		}
	}
}

