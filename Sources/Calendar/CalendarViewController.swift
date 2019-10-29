/*
 * Copyright (C) PagesJaunes, SoLocal Group - All Rights Reserved.
 *
 * Unauthorized copying of this file, via any medium is strictly prohibited.
 * Proprietary and confidential.
 */

/* _____       _                _            _   _ _               _____             _             _ _
  /  __ \     | |              | |          | | | (_)             /  __ \           | |           | | |
  | /  \/ __ _| | ___ _ __   __| | __ _ _ __| | | |_  _____      _| /  \/ ___  _ __ | |_ _ __ ___ | | | ___ _ __
  | |    / _` | |/ _ \ '_ \ / _` |/ _` | '__| | | | |/ _ \ \ /\ / / |    / _ \| '_ \| __| '__/ _ \| | |/ _ \ '__|
  | \__/\ (_| | |  __/ | | | (_| | (_| | |  \ \_/ / |  __/\ V  V /| \__/\ (_) | | | | |_| | | (_) | | |  __/ |
   \____/\__,_|_|\___|_| |_|\__,_|\__,_|_|   \___/|_|\___| \_/\_/  \____/\___/|_| |_|\__|_|  \___/|_|_|\___|_|
  13700 Made in Marignane
 */

//swiftlint:disable type_body_length
//swiftlint:disable file_length
//swiftlint:disable function_body_length

import Foundation
import UIKit

// MARK: - CalendarViewController

/// Display time slot, month and day, and allow the user to select a time slot.
public class CalendarViewController: UIViewController {

  // MARK: Private properties

  // MARK: ViewModels

  // MARK: Theme

  /// Store the `CalendarViewController` theme
  private let theme: CalendarViewControllerTheme

  /// DayListView `ViewModel`
  private let dayListViewModel: DayListViewModel

  /// MonthSelectorView `ViewModel`
  private let monthListViewModel: MonthListViewModel

  /// Slot collectionView `ViewModel`
  private let slotListViewModel: TimeSlotListViewModel

  // MARK: Configuration

  /// Define if the EffectView should be used in the CollectionView header
  private let shouldUseEffectView: Bool

  private let shouldUseBigCell: Bool

  // MARK: DataController

  /// Represent the data State, dates, current selected day, current selected slot, and provide loading action methods.
  /// This DataController is shared with all ViewModels so all ViewModel are synchronised on the same data.
  private let dataController: CalendarDataController

  // MARK: Delegate

  public weak var delegate: CalendarViewControllerDelegate?

  // MARK: Public methods

  // MARK: Init

  /// Calendar Init
  ///
  /// - Parameters:
  ///   - dataProvider: `CalendarDataProvider` concrete implentation provide by implemententing `loadData` and `loadNexResult` methods
  ///   - periodFormater: `CalendarPeriodFormater` concrete implentation provide moring and afteroon name and logic to seperate them
  ///   - shouldUseEffectView: Bool define if `UIEffectView` blur should be used in the
  /// `UICollectionView` header (`UIEffectView` blur is an heavy process and should be perfom only on powerfull device)
  public init(configuration: Configuration) {

    self.dataController = CalendarDataController(dataProvider: configuration.dataProvider,
                                                 periodFormater: configuration.periodFormater,
                                                 locale: configuration.locale)
    
    self.dayListViewModel = DayListViewModel(dataController: dataController)
    self.monthListViewModel = MonthListViewModel(dataController: dataController)
    self.slotListViewModel = TimeSlotListViewModel(dataController: dataController)
    self.shouldUseEffectView = configuration.shouldUseEffectView
    self.theme = configuration.theme
    self.shouldUseBigCell = configuration.cellSize.isBigCell
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Private Properties

  // MARK: UIView

  /// DarkView presenting on top of the ParentViewController view during the presentation process (only on iPhone)
  private lazy var presentingOverlayView: UIView = {
    let dest = UIView()
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Main `UICollectionView` cell are Slots, and header contain `DaySelectorView` and `MonthSelectorView`
  private let collectionView: UICollectionView = {
    let layout = CalendarViewLayout()
    let dest = UICollectionView(frame: .zero, collectionViewLayout: layout)
    dest.translatesAutoresizingMaskIntoConstraints = false
    dest.clipsToBounds = true
    return dest
  }()

  /// This spinner is display during the inital data loading
  private let spinner: UIActivityIndicatorView = {
    let dest: UIActivityIndicatorView
    if #available(iOS 13, *) {
      dest = UIActivityIndicatorView(style: .medium)
    }
    else {
      dest = UIActivityIndicatorView(style: .gray)
    }
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Cancel button on the top left of the View, will call the delegate method: `didTapOnCancelButton`
  private let cancelButton: UIButton = {
    let dest = UIButton(frame: .zero)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Ok button on the top right of the View, will call the delegate method: `didTapOnOkButton`
  private let okButton: UIButton = {
    let dest = UIButton(frame: .zero)
    dest.translatesAutoresizingMaskIntoConstraints = false
    return dest
  }()

  /// Configure the CollectionView, setup the apearance and register
  /// `SlotCell` and `NoSlotCell` cell and `HeaderCell`, and `SlotHeaderCell` header
  private func setupCollectionView() {
    self.collectionView.isOpaque = true
    self.collectionView.dataSource = self
    self.collectionView.delegate = self
    self.collectionView.contentInsetAdjustmentBehavior = .never
    self.collectionView.showsHorizontalScrollIndicator = false
    self.collectionView.showsVerticalScrollIndicator = false

    self.collectionView.register(CalendarSlotCell.self,
                                 forCellWithReuseIdentifier: CalendarSlotCell.reusueCellIdentifier)

    self.collectionView.register(HeaderCell.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: HeaderCell.reusueCellIdentifier)

    self.collectionView.register(SlotHeaderCell.self,
                                 forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                 withReuseIdentifier: SlotHeaderCell.reusueCellIdentifier)

    self.collectionView.register(NoSlotCell.self, forCellWithReuseIdentifier: NoSlotCell.reusueCellIdentifier)
  }

  /// Present an error message if an error occur during the initial data loading
  private func displayErrorMessage() {
    let alert = UIAlertController(title: "Oups !",
                                  message: "Une erreur technique est survenue.\nVeuillez réessayer.",
                                  preferredStyle: UIAlertController.Style.alert)

    let retry = UIAlertAction(title: "Réessayer", style: .default) { [weak self] _ in
      self?.dataController.loadData()
    }

    let cancel = UIAlertAction(title: "Fermer", style: .cancel, handler: nil)

    alert.addAction(retry)
    alert.addAction(cancel)

    self.present(alert, animated: true, completion: nil)

  }

  /// Present an error message if there is no slots to display
  private func displayNoSlotMessage() {
    let alert = UIAlertController(title: "Oups !",
                                  message: "Aucun créneau disponible.",
                                  preferredStyle: .alert)

    let cancel = UIAlertAction(title: "Fermer", style: .cancel) { [weak self] _ in
      guard let `self` = self else { return }
      self.delegate?.calendar(self, didTapOnCancelButton: self.cancelButton)
    }

    alert.addAction(cancel)
    self.present(alert, animated: true, completion: nil)
  }

  /// Start data loading, and subscribe to DataController `initialLoadingState` Observable property
  /// and `selectSlot` observable property.
  private func setupDataController() {

    self.spinner.hidesWhenStopped = true
    self.collectionView.alpha = 0.0
    self.spinner.startAnimating()

    self.dataController.initialLoadingState.bind { [weak self] (_, newValue) in
      guard let `self` = self else { return }
      switch newValue {
      case .error:
        self.displayErrorMessage()
      case .loading:
        break
      case .noResult:
        self.displayNoSlotMessage()
      case .ready:
        self.spinner.stopAnimating()
        UIView.animate(withDuration: 0.35, animations: { self.collectionView.alpha = 1.0 })
      }
    }

    self.dataController.selectedSlot.bind { [weak self] _, value in
      guard let `self` = self else { return }
      DispatchQueue.main.async {
        self.okButton.isEnabled = (value != nil )
        if value == nil {
          if let indexPath = self.collectionView.indexPathsForSelectedItems {
            indexPath.forEach { self.collectionView.deselectItem(at: $0, animated: false) }
          }
        }
      }
    }

    self.okButton.isEnabled = (self.dataController.selectedSlot.value != nil)
    self.dataController.loadData()
  }

  /// Setup the layout of spinner, cancelButton, okButton and collectionView
  private func setupLayout() {
    var constraints = [NSLayoutConstraint]()

    // spinner
    constraints.append(self.spinner.centerXAnchor.constraint(equalTo: self.view.centerXAnchor))
    constraints.append(self.spinner.centerYAnchor.constraint(equalTo: self.view.centerYAnchor))

    // cancelButton
    constraints.append(self.cancelButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: CalendarMetrics.grid(4)))
    constraints.append(self.cancelButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: CalendarMetrics.grid(3)))

    // okButton
    constraints.append(self.okButton.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -CalendarMetrics.grid(4)))
    constraints.append(self.okButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: CalendarMetrics.grid(3)))

    // collectionView
    constraints.append(self.collectionView.topAnchor.constraint(equalTo: self.okButton.bottomAnchor))
    constraints.append(self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor))
    constraints.append(self.collectionView.leftAnchor.constraint(equalTo: self.view.leftAnchor))
    constraints.append(self.collectionView.rightAnchor.constraint(equalTo: self.view.rightAnchor))

    NSLayoutConstraint.activate(constraints)
  }

  private func setupAccessibility() {
    self.view.isAccessibilityElement = false
    self.view.accessibilityIdentifier = "CALENDAR MAIN"

    self.collectionView.isAccessibilityElement = false
    self.collectionView.accessibilityIdentifier = "CALENDAR SLOT LIST"

    self.okButton.isAccessibilityElement = false
    self.okButton.accessibilityIdentifier = "CALENDAR OK BUTTON"
  }

  /// Setup the view hierarchy
  private func setupView() {
    self.view.addSubview(self.collectionView)
    self.view.addSubview(self.spinner)
    self.view.addSubview(self.okButton)
    self.view.addSubview(self.cancelButton)
  }

  /// Setup the viewModel delegate
  private func setupViewModel() {
    self.slotListViewModel.delegate = self

    self.slotListViewModel.accessibilitySelectedSlotValue.bind { [weak self] _, newSlotAccessibilityValue in
      guard let `self` = self else { return }
      self.collectionView.accessibilityValue = newSlotAccessibilityValue
    }
    self.collectionView.accessibilityValue = self.slotListViewModel.accessibilitySelectedSlotValue.value
  }

  /// handle when the user touch the cancel button
  @objc private func userDidTouchCancelButton() {
    self.delegate?.calendar(self, didTapOnCancelButton: self.okButton)
  }

  /// handle when the user touch the OK button
  @objc private func userDidTouchOkButton() {
    guard let slot = self.dataController.selectedSlotModel else { return }
    self.delegate?.calendar(self, didTapOnOkButton: slot.originalDate, andCode: slot.code)
  }

  /// Setup ok and cancel button (theme, text and target)
  /// a Tap gesture is added to the presentingOverlayView
  private func setupButtons() {

    self.cancelButton.setTitleColor(self.theme.okCancelButtons.enabledColor, for: .normal)
    self.okButton.setTitleColor(self.theme.okCancelButtons.enabledColor, for: .normal)
    self.okButton.setTitleColor(self.theme.okCancelButtons.disabledColor, for: .disabled)

    self.okButton.titleLabel?.font = self.theme.okCancelButtons.buttonFont
    self.cancelButton.titleLabel?.font = self.theme.okCancelButtons.buttonFont

    self.cancelButton.setTitle("Annuler", for: .normal)
    self.okButton.setTitle("OK", for: .normal)
    self.okButton.addTarget(self, action: #selector(userDidTouchOkButton), for: .touchUpInside)
    self.cancelButton.addTarget(self, action: #selector(userDidTouchCancelButton), for: .touchUpInside)

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userDidTouchCancelButton))
    tapGesture.numberOfTapsRequired = 1
    self.presentingOverlayView.addGestureRecognizer(tapGesture)
  }

  private func setupStyle() {
    self.view.backgroundColor = UIColor.white
    self.collectionView.backgroundColor = UIColor.white
  }

  /// Main Setup method, this method is called by the `viewDidLoad` method and will set:
  /// - View hierarchy
  /// - Layout
  /// - Configure the collectionView
  /// - Setup the ViewModel delegate
  /// - Setup the dataController, start data loadind and subscribe to observables properties
  /// - Setup the viewController theme
  /// - Setup buttons
  private func setup() {
    self.setupView()
    self.setupLayout()
    self.setupCollectionView()
    self.setupViewModel()
    self.setupDataController()
    self.setupStyle()
    self.setupButtons()
    self.setupAccessibility()
  }

  override public func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    self.delegate?.calendar(self, calendarDidAppearOnViewController: self.presentingViewController)
  }

  override public func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
}

// MARK: - UICollectionViewDelegate

extension CalendarViewController: UICollectionViewDelegate {
  public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    self.slotListViewModel.userDidSelectSlot(slotIndexPath: indexPath)
    self.delegate?.calendar(self, didSelectDateAtIndexPath: indexPath)
  }
}

// MARK: - UICollectionViewDataSource
extension CalendarViewController: UICollectionViewDataSource {

  public func numberOfSections(in collectionView: UICollectionView) -> Int {
    return self.slotListViewModel.sectionCount
  }

  public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if section == 0 {
      return 0
    } else {
      return self.slotListViewModel.itemCount
    }
  }

  public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

    guard self.slotListViewModel.shouldDisplayNoSlotCell == false  else {
      let dequeueCell = collectionView.dequeueReusableCell(withReuseIdentifier: NoSlotCell.reusueCellIdentifier, for: indexPath)
      guard let castedCell = dequeueCell as? NoSlotCell else { return dequeueCell }
      castedCell.delegate = self
      guard let model = self.slotListViewModel.noSlotModel else { return dequeueCell }

      castedCell.configure(viewModel: model, theme: self.theme)
      return castedCell
    }

    let dequeueCell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarSlotCell.reusueCellIdentifier, for: indexPath)

    guard indexPath.section == 1 else {
      return dequeueCell
    }

    guard let dest = dequeueCell as? CalendarSlotCell else {
      return dequeueCell
    }

    guard let model = self.slotListViewModel[indexPath.item] else { return dequeueCell }
    dest.configure(model: model, theme: self.theme)

    return dest
  }

  public func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {

    if indexPath.section == 0 {

      let hederView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: HeaderCell.reusueCellIdentifier, for: indexPath)

      guard let castedHeaderView = hederView as? HeaderCell else { return hederView }


      let configuration = HeaderCellConfiguration(monthListViewModel: self.monthListViewModel,
                                                  dayListViewModel: self.dayListViewModel,
                                                  delegate: self,
                                                  shouldUseEffectView:self.shouldUseEffectView,
                                                  theme: self.theme)

      castedHeaderView.configure(configuration: configuration)
      return castedHeaderView
    } else {

      let headerCellView = collectionView.dequeueReusableSupplementaryView(
        ofKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: SlotHeaderCell.reusueCellIdentifier, for: indexPath)

      guard let castedHeaderCellView = headerCellView as? SlotHeaderCell else { return headerCellView }
      castedHeaderCellView.configure(viewModel: self.slotListViewModel)
      castedHeaderCellView.delegate = self
      return castedHeaderCellView
    }
  }
}

// MARK: - TimeSlotListViewModelDelegate

extension CalendarViewController: TimeSlotListViewModelDelegate {
  func reloadSlots() {
    let oldContentOffset = self.collectionView.contentOffset
    self.collectionView.reloadData()
    self.collectionView.setCollectionViewLayout(CalendarViewLayout(), animated: false) { _ in
      if oldContentOffset.y + self.collectionView.frame.size.height > self.collectionView.contentSize.height {
        self.collectionView.contentOffset = CGPoint(x: 0, y: self.collectionView.contentSize.height - self.collectionView.frame.size.height)
      } else {
        self.collectionView.contentOffset = oldContentOffset
      }
    }
  }
}

// MARK: - CalendarFlowLayoutDelegate

extension CalendarViewController: CalendarViewLayoutDelegate {
  var shouldDisplayNoSlot: Bool {
    return self.slotListViewModel.shouldDisplayNoSlotCell
  }

  var shouldUseBigCellSize: Bool {
    return self.shouldUseBigCell
  }
}

// MARK: - NoSlotCellDelegate

extension CalendarViewController: NoSlotCellDelegate {

  func noSlotCellView(_ noSlotCellView: NoSlotCell, didTapOnNextDispoButton button: UIButton) {
    self.delegate?.calendar(self, didTapOnNextDispoButton: button)
  }

  func noSlotCellView(_ noSlotCellView: NoSlotCell, didTapOnPreviousDispoButton button: UIButton) {
    self.delegate?.calendar(self, didTapOnPreviousDispoButton: button)
  }
}

// MARK: - DaySelectorViewDelegate

extension CalendarViewController: DaySelectorViewDelegate {

  func daySelectorView(_ daySelectorView: DaySelectorView, didSelectDay indexPath: IndexPath) {
    self.delegate?.calendar(self, didSelectDay: indexPath)
  }
}

// MARK: - MonthSelectorViewDelegate

extension CalendarViewController: MonthSelectorViewDelegate {
  func monthSelectorView(_ monthSelectorView: MonthSelectorView, didTapOnNextMonthButton button: UIButton) {
    self.delegate?.calendar(self, didTapOnNextMonthButton: button)
  }

  func monthSelectorView(_ monthSelectorView: MonthSelectorView, didTapOnPreviousMonthButton button: UIButton) {
    self.delegate?.calendar(self, didTapOnPreviousMonthButton: button)
  }

  func monthSelectorView(_ monthSelectorView: MonthSelectorView, didScrollToMonthIndexPath indexPath: IndexPath) {
    self.delegate?.calendar(self, didScrollToMonthIndexPath: indexPath)
  }
}

// MARK: - SlotHeaderCellDelegate

extension CalendarViewController: SlotHeaderCellDelegate {
  func slotHeaderCell(_ slotHeaderCell: SlotHeaderCell, didSelectPeriod period: SlotHeaderCellDelegatePeriod, onSender: UIView) {
    self.delegate?.calendar(self, didSelectPeriod: period, onSender: onSender)
  }
}
