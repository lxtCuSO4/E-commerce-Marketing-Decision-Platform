export function getMenuNodeId(menu, fallback = "") {
	if (!menu || typeof menu !== "object") {
		return fallback
	}

	const stableId = [menu.path, menu.url, menu.id]
		.find((value) => typeof value === "string" && value.trim())
		?.trim()

	if (stableId) {
		return stableId.toLowerCase()
	}

	if (typeof menu.name === "string" && menu.name.trim()) {
		return `name:${menu.name.trim()}`
	}

	return fallback
}

export function withStableMenuIds(menus = [], branch = "menu") {
	if (!Array.isArray(menus)) {
		return []
	}

	return menus.map((menu, index) => {
		const fallback = `${branch}-${index}`
		const children = withStableMenuIds(menu.children, `${getMenuNodeId(menu, fallback)}-child`)

		return {
			...menu,
			id: getMenuNodeId(menu, fallback),
			children,
		}
	})
}

export function getSidebarLogo(icon) {
	return typeof icon === "string" && icon.trim() ? icon.trim() : "/logo.svg"
}
