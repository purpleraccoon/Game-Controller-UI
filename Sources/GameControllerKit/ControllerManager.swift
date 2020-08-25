//
//  ControllerManager.swift
//  
//
//  Created by Jeremy Kemery on 8/25/20.
//

import GameController
import Combine

@available(OSX 10.15, *)
class ControllerManager {

	public private(set) var controllers: [GCController] = []

	private var addedController: AnyCancellable? = nil
	private var removedController: AnyCancellable? = nil

	init() {
		defer {
			addedController = NotificationCenter.default
				.publisher(for: .GCControllerDidConnect)
				.receive(on: DispatchQueue.main)
				.sink { (notification) in
					if let controller = notification.object as? GCController {
						self.add(controller: controller)
					}
				}

			removedController = NotificationCenter.default
				.publisher(for: .GCControllerDidDisconnect)
				.receive(on: DispatchQueue.main)
				.sink { (notification) in
					if let controller = notification.object as? GCController {
						self.remove(controller: controller)
					}
				}
		}
	}

	private func add(controller: GCController) {
		guard !controllers.contains(controller) else { fatalError("Controller already in manager") }

		if !controllers.contains(controller) {
			controllers.append(controller)
			updatePlayerIndices()
//			let addedIndex = controllers.count - 1
		}
	}

	private func remove(controller: GCController) {

		if let index = controllers.firstIndex(of: controller) {
			controllers.remove(at: index)
			updatePlayerIndices()
//			let removedIndex = index
		}

		fatalError("Controller not in manager")
	}

	private func updatePlayerIndices() {
		let _ = controllers.enumerated().map { $1.playerIndex = GCControllerPlayerIndex(rawValue: $0) ??  GCControllerPlayerIndex(rawValue: 0)! }
	}

}
