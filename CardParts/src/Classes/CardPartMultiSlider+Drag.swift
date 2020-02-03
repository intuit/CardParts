//
//  CardPartMultiSlider+Drag.swift
//  CardPartMultiSlider
//
//  Created by Brian Carreon on 25.10.2018.
//

import UIKit

extension CardPartMultiSlider: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc open func didDrag(_ panGesture: UIPanGestureRecognizer) {
        switch panGesture.state {
        case .began:
            // determine thumb to drag
            let location = panGesture.location(in: slideView)
            draggedThumbIndex = closestThumb(point: location)
        case .ended, .cancelled, .failed:
            sendActions(for: .touchUpInside) // no bounds check for now (.touchUpInside vs .touchUpOutside)
            if !isContinuous { sendActions(for: [.valueChanged, .primaryActionTriggered]) }
        default:
            break
        }
        guard draggedThumbIndex >= 0 else { return }

        let slideViewLength = slideView.bounds.size(in: orientation)
        var targetPosition = panGesture.location(in: slideView).coordinate(in: orientation)
        let stepSizeInView = (snapStepSize / (maximumValue - minimumValue)) * slideViewLength

        // snap translation to stepSizeInView
        if snapStepSize > 0 {
            let translationSnapped = panGesture.translation(in: slideView).coordinate(in: orientation).rounded(stepSizeInView)
            if 0 == Int(translationSnapped) { return }
            panGesture.setTranslation(.zero, in: slideView)
        }

        // don't cross prev/next thumb and total range
        targetPosition = boundedDraggedThumbPosition(targetPosition: targetPosition, stepSizeInView: stepSizeInView)

        // change corresponding value
        updateDraggedThumbValue(relativeValue: targetPosition / slideViewLength)

        UIView.animate(withDuration: 0.1) {
            self.updateDraggedThumbPositionAndLabel()
            self.layoutIfNeeded()
        }

        if isContinuous { sendActions(for: [.valueChanged, .primaryActionTriggered]) }
    }

    /// adjusted position that doesn't cross prev/next thumb and total range
    private func boundedDraggedThumbPosition(targetPosition: CGFloat, stepSizeInView: CGFloat) -> CGFloat {
        var delta = snapStepSize > 0 ? stepSizeInView : thumbViews[draggedThumbIndex].frame.size(in: orientation) / 2
        delta = keepsDistanceBetweenThumbs ? delta : 0
        if orientation == .horizontal { delta = -delta }
        let bottomLimit = draggedThumbIndex > 0
            ? thumbViews[draggedThumbIndex - 1].center.coordinate(in: orientation) - delta
            : slideView.bounds.bottom(in: orientation)
        let topLimit = draggedThumbIndex < thumbViews.count - 1
            ? thumbViews[draggedThumbIndex + 1].center.coordinate(in: orientation) + delta
            : slideView.bounds.top(in: orientation)
        if orientation == .vertical {
            return min(bottomLimit, max(targetPosition, topLimit))
        } else {
            return max(bottomLimit, min(targetPosition, topLimit))
        }
    }

    private func updateDraggedThumbValue(relativeValue: CGFloat) {
        var newValue = relativeValue * (maximumValue - minimumValue)
        if orientation == .vertical {
            newValue = maximumValue - newValue
        } else {
            newValue += minimumValue
        }
        newValue = newValue.rounded(snapStepSize)
        guard newValue != value[draggedThumbIndex] else { return }
        isSettingValue = true
        value[draggedThumbIndex] = newValue
        isSettingValue = false
    }

    private func updateDraggedThumbPositionAndLabel() {
        positionThumbView(draggedThumbIndex)
        if draggedThumbIndex < valueLabels.count {
            updateValueLabel(draggedThumbIndex)
            if isValueLabelRelative && draggedThumbIndex + 1 < valueLabels.count {
                updateValueLabel(draggedThumbIndex + 1)
            }
        }
    }

    private func closestThumb(point: CGPoint) -> Int {
        var closest = -1
        var minimumDistance = CGFloat.greatestFiniteMagnitude
        let pointCoordinate = point.coordinate(in: orientation)
        for i in 0 ..< thumbViews.count {
            guard !disabledThumbIndices.contains(i) else { continue }
            let thumbCoordinate = thumbViews[i].center.coordinate(in: orientation)
            let distance = abs(pointCoordinate - thumbCoordinate)
            if distance > minimumDistance { break }
            if i > 0 && closest == i - 1 && thumbViews[i].center == thumbViews[i - 1].center { // overlapping thumbs
                let greaterSign: CGFloat = orientation == .vertical ? -1 : 1
                if greaterSign * thumbCoordinate < greaterSign * pointCoordinate {
                    closest = i
                }
                break
            }
            minimumDistance = distance
            if distance < thumbViews[i].diagonalSize {
                closest = i
            }
        }
        return closest
    }
}
