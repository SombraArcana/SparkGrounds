--!strict
-- BuildModeState008 (SPEC-008): fonte única do modo de construção, sem `game`, sem UI.
-- Default "chao". Troca inválida é rejeitada sem efeito.

export type BuildMode = "chao" | "parede"

local current: BuildMode = "chao"

local BuildModeState008 = {}

function BuildModeState008.isValid(mode: string): boolean
	return mode == "chao" or mode == "parede"
end

function BuildModeState008.get(): BuildMode
	return current
end

function BuildModeState008.set(mode: BuildMode): BuildMode
	assert(BuildModeState008.isValid(mode), "mode inválido, esperado chao|parede")
	local previous = current
	current = mode
	return previous
end

return BuildModeState008
