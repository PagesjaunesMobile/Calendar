/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

import Foundation
import UIKit

// MARK: - SlotHeaderCellDelegatePeriod

/// Describe the selected period morning or afernoon
///
/// - morning: morning period
/// - afternoon: afternoon period
public enum SlotHeaderCellDelegatePeriod {
  case morning
  case afternoon
}

// MARK: - SlotHeaderCellDelegate

/// `SlotHeaderCellDelegate` delegate protocol notify when an user event occured
protocol SlotHeaderCellDelegate: class {
  func slotHeaderCell(_ slotHeaderCell: SlotHeaderCell, didSelectPeriod period: SlotHeaderCellDelegatePeriod, onSender: UIView)
}

// MARK: - SlotHeaderCell

/// Display the Matin / Apres midi segmented control on top of slots
class SlotHeaderCell: UICollectionReusableView {

  // MARK: Public properties

  /// The delegate is notify every time the user toggle between morning and afternoon
  weak var delegate: SlotHeaderCellDelegate?

  // MARK: Private static properties

  /// Reusue cell indetifier should be use in collectionView register method.
  static let reusueCellIdentifier = String(describing: SlotHeaderCell.self)

  /// Return the cell height, usefull in `CalendarViewLayout`
  static let slotHeaderCellHeight: CGFloat = CalendarMetrics.grid(22)

  // MARK: Private properties

  // MARK: UIView

  /// Display matin / apres midi View
  private let segmentedControl: UISegmentedControl = {
    let dest = UISegmentedControl()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  // MARK: ViewModel

  /// Slot header viewModel usefull to get user selection
  /// and matin apres midi text, the viewModel is notify
  /// when the user perform an action
  private var viewModel: TimeSlotListViewModel?

  // MARK: Private methods

  /// Setup subview layout
  private func setupLayout() {
    var constraints = [NSLayoutConstraint]()

    constraints.append(self.segmentedControl.topAnchor.constraint(equalTo: self.topAnchor, constant: CalendarMetrics.grid(6)))
    constraints.append(self.segmentedControl.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: CalendarMetrics.grid(6)))
    constraints.append(self.segmentedControl.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -CalendarMetrics.grid(6)))
    constraints.append(self.segmentedControl.centerXAnchor.constraint(equalTo: self.centerXAnchor))
    constraints.append(self.segmentedControl.widthAnchor.constraint(equalToConstant: CalendarMetrics.grid(81)))
    constraints.append(self.segmentedControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -CalendarMetrics.grid(8)))

    NSLayoutConstraint.activate(constraints)
  }

  /// Setup segmentedControl with correct morning / afternoon name,
  /// setup the user selection and subscribe to `segmentedControlIndexToDisplay`
  /// Observable property
  private func setupModel() {
    guard let viewModel = self.viewModel else { return }

    self.segmentedControl.insertSegment(withTitle: viewModel.moringPeriod.periodName, at: 0, animated: false)
    self.segmentedControl.insertSegment(withTitle: viewModel.afternoonPeriod.periodName, at: 1, animated: false)
    self.segmentedControl.addTarget(self, action: #selector(segmentedControllDidChange), for: UIControl.Event.valueChanged)

    viewModel.segmentedControlIndexToDisplay.bind { [weak self] _, indexToDisplay in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        guard indexToDisplay >= 0, indexToDisplay < self.segmentedControl.numberOfSegments else { return }
        self.segmentedControl.selectedSegmentIndex = indexToDisplay
      }
    }
    self.segmentedControl.selectedSegmentIndex = viewModel.segmentedControlIndexToDisplay.value
  }

  /// Setup the view hierarchy
  private func setupView() {
    self.addSubview(self.segmentedControl)
  }

  /// Setup view hierarchy and layout
  private func setup() {
    self.setupView()
    self.setupLayout()
  }

  // MARK: Handle User action

  /// Handle user action when the user change the value of the segmentedControl
  /// the delegate and the viewModel are notify
  @objc private func segmentedControllDidChange() {
    if self.segmentedControl.selectedSegmentIndex == 0 {
      self.viewModel?.userDidSelectMoringPeriod()
      self.delegate?.slotHeaderCell(self, didSelectPeriod: .morning, onSender: self.segmentedControl)
    } else {
      self.viewModel?.userDidSelectAfternoonPeriod()
      self.delegate?.slotHeaderCell(self, didSelectPeriod: .afternoon, onSender: self.segmentedControl)
    }
  }

  // MARK: Public method

  /// Configure the SlotHeader with the corresponding viewModel
  ///
  /// Designed to be called from `cellForItemAt` in `UICollectionViewDataSource` method
  ///
  /// - Parameter viewModel: SlotHeader viewModel
  func configure(viewModel: TimeSlotListViewModel) {
    guard self.viewModel == nil else {
      self.segmentedControl.selectedSegmentIndex = viewModel.segmentedControlIndexToDisplay.value
      return
    }
    self.viewModel = viewModel
    self.setupModel()
  }

  // MARK: UICollectionViewCell override

  /// Reset the cell, and remove observable subscription
  override func prepareForReuse() {
    super.prepareForReuse()
    guard let viewModel = self.viewModel else { return }
    viewModel.segmentedControlIndexToDisplay.removeAllObservers()
  }

  // MARK: Init

  /// SlotHeader init, basic UICollectionReusableView init override
  /// just call setup
  ///
  /// - Parameter frame: given frame
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setup()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
