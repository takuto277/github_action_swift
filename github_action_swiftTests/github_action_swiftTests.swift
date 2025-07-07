//
//  github_action_swiftTests.swift
//  github_action_swiftTests
//
//  Created by takuto ono on 2025/07/07.
//

import Testing

struct github_action_swiftTests {
    @Test func example() async throws {
        // 基本的な計算のテスト
        let result = 2 + 2
        #expect(result == 4)
    }

    @Test func stringTest() async throws {
        // 文字列のテスト
        let greeting = "Hello, world!"
        #expect(greeting.contains("world"))
        #expect(greeting.count == 13)
    }

    @Test func arrayTest() async throws {
        // 配列のテスト
        let numbers = [1, 2, 3, 4, 5]
        #expect(numbers.count == 5)
        #expect(numbers.first == 1)
        #expect(numbers.last == 5)
    }

    @Test func asyncTest() async throws {
        // 非同期処理のテスト例
        await Task.sleep(nanoseconds: 1_000_000) // 1ms待機
        let value = await performAsyncOperation()
        #expect(value == "completed")
    }

    private func performAsyncOperation() async -> String {
        "completed"
    }
}
