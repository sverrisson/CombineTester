//
//  ControlPublisher.swift
//  CombineTester
//
//  Created by Hannes Sverrisson on 26/10/2019.
//  Copyright © 2019 Hannes Sverrisson. All rights reserved.
//

import Foundation
import UIKit
import Combine

// Source for following: https://www.avanderlee.com/swift/custom-combine-publisher/

/// A custom subscription to capture UIControl target events.
final class ControlSubscription<SubscriberType: Subscriber, Control: UIControl>: Subscription where SubscriberType.Input == Control {
    private var subscriber: SubscriberType?
    private let control: Control

    init(subscriber: SubscriberType, control: Control, event: UIControl.Event) {
        self.subscriber = subscriber
        self.control = control
        control.addTarget(self, action: #selector(eventHandler), for: event)
    }

    func cancel() {
        subscriber = nil
    }

    @objc private func eventHandler() {
        _ = subscriber?.receive(control)
    }
    
    func request(_ demand: Subscribers.Demand) {
        print("Demand is: \(demand) from \(demand.hashValue)")
    }
}

/// A custom `Publisher` to work with our custom `UIControlSubscription`.
struct ControlPublisher<Control: UIControl>: Publisher {
    typealias Output = Control
    typealias Failure = Never

    let control: Control
    let controlEvents: UIControl.Event

    init(control: Control, events: UIControl.Event) {
        self.control = control
        self.controlEvents = events
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, S.Failure == ControlPublisher.Failure, S.Input == ControlPublisher.Output {
        let subscription = ControlSubscription(subscriber: subscriber, control: control, event: controlEvents)
        subscriber.receive(subscription: subscription)
    }
}

/// Extending the `UIControl` types to be able to produce a `UIControl.Event` publisher.
protocol CombineCompatible { }
extension UIControl: CombineCompatible { }
extension CombineCompatible where Self: UIControl {
    func publisher(for events: UIControl.Event) -> ControlPublisher<UIControl> {
        ControlPublisher(control: self, events: events)
    }
}
