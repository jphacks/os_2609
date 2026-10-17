//
//  ARCaptureViewModelTests.swift
//  SunshineTests
//

import Testing
@testable import Sunshine

struct ARCaptureViewModelTests {

    @Test func 初期状態ではモンスターは未配置() {
        let viewModel = ARCaptureViewModel()

        #expect(viewModel.isMonsterPlaced == false)
        #expect(viewModel.statusMessage == "床を映して、ゆっくり動かしてください")
    }

    @Test func アンカーが固定されると配置済みになる() {
        let viewModel = ARCaptureViewModel()

        viewModel.monsterAnchorStateChanged(isAnchored: true)

        #expect(viewModel.isMonsterPlaced)
        #expect(viewModel.statusMessage == "\(viewModel.monster.name)が現れた！")
    }

    @Test func アンカーが外れると未配置に戻る() {
        let viewModel = ARCaptureViewModel()
        viewModel.monsterAnchorStateChanged(isAnchored: true)

        viewModel.monsterAnchorStateChanged(isAnchored: false)

        #expect(viewModel.isMonsterPlaced == false)
    }
}
