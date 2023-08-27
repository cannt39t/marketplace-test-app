//
//  CoreDataManager.swift
//  AvitoTestApp
//
//  Created by Илья Казначеев on 27.08.2023.
//

import UIKit
import CoreData

final class CoreDataMamanager: NSObject {
	
	public static let shared = CoreDataMamanager()
	private override init() {}
	
	private var appDelegate: AppDelegate {
		UIApplication.shared.delegate as! AppDelegate
	}
	
	private var context: NSManagedObjectContext {
		appDelegate.persistentContainer.viewContext
	}
	
	func createAdvInfo(_ id: String, isViewed: Bool, isFavorite: Bool) {
		guard let advertisementInfoDescription = NSEntityDescription.entity(forEntityName: "AVAdvertisementInfo", in: context) else {
			return
		}
		
		let photo = AVAdvertisementInfo(entity: advertisementInfoDescription, insertInto: context)
		photo.id = id
		photo.isViewed = isViewed
		photo.isFavorite = isFavorite
		
		appDelegate.saveContext()
	}
	
	func fetchAdv(with id: String) -> AVAdvertisementInfo? {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AVAdvertisementInfo")
		fetchRequest.predicate = NSPredicate(format: "id == %@", id)
		do {
			let photos = try? context.fetch(fetchRequest) as? [AVAdvertisementInfo]
			return photos?.first
		}
	}
	
	func updataAdv(with id: String, newIsFavorite: Bool, newIsViewed: Bool) {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AVAdvertisementInfo")
		fetchRequest.predicate = NSPredicate(format: "id == %@", id)
		do {
			guard let photos = try? context.fetch(fetchRequest) as? [AVAdvertisementInfo],
				  let photo = photos.first else { return }
			photo.isViewed = newIsViewed
			photo.isFavorite = newIsFavorite
		}
		
		appDelegate.saveContext()
	}
	
	func deletaAllAdv() {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AVAdvertisementInfo")
		do {
			let photos = try? context.fetch(fetchRequest) as? [AVAdvertisementInfo]
			photos?.forEach { context.delete($0) }
		}
		
		appDelegate.saveContext()
	}
	
}
