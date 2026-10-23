import test from "node:test"
import assert from "node:assert/strict"

import { getMenuNodeId, withStableMenuIds, getSidebarLogo } from "./layout-runtime.js"

test("getMenuNodeId prefers path and url for stable ids", () => {
	assert.equal(
		getMenuNodeId({
			path: "/ai-module",
			url: "/ai-module",
			name: "AI 智能分析",
		}),
		"/ai-module",
	)
})

test("withStableMenuIds fills missing ids recursively", () => {
	const menus = withStableMenuIds([
		{
			name: "AI 智能分析",
			path: "/ai-module",
			children: [
				{
					name: "智能推荐与报告",
					url: "/ai-module/intelligent-recommendation-report",
				},
			],
		},
	])

	assert.equal(menus[0].id, "/ai-module")
	assert.equal(menus[0].children[0].id, "/ai-module/intelligent-recommendation-report")
})

test("getSidebarLogo falls back to public logo when runtime icon is missing", () => {
	assert.equal(getSidebarLogo(""), "/logo.svg")
	assert.equal(getSidebarLogo("   "), "/logo.svg")
})

test("getSidebarLogo preserves configured icon urls", () => {
	assert.equal(getSidebarLogo("https://example.com/logo.png"), "https://example.com/logo.png")
})
