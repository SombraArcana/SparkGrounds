# Notas técnicas — Grid e construção
**Fonte:** Human Loop - Chatbot B
**Data:** 2026-10-03

## 1. Estrutura de dados para o Grid (X, Z)
Recomendado: tabela esparsa com chave composta, rápida e simples.

```lua
local Grid = {} -- [x] = { [z] = { tipo = "chao" | "parede", ... } }

-- Acesso O(1):
local cell = Grid[x] and Grid[x][z]
```

Alternativa ainda mais rápida em mapas grandes: chave string `"x_z"` ou número `x * MAX_Z + z`. Evite arrays densos se o mapa for esparso.

## 2. Object Pooling em Luau

```lua
local Pool = {}
local available = {}
local active = {}

function Pool.get(template)
    local obj = table.remove(available) or template:Clone()
    active[obj] = true
    return obj
end

function Pool.release(obj)
    if active[obj] then
        obj.Parent = nil -- ou pasta "PoolStorage"
        active[obj] = nil
        table.insert(available, obj)
    end
end
```

Nunca use `Destroy()`. Mantenha o pool em uma pasta escondida no workspace ou em `ReplicatedStorage`.

## 3. Fluxo seguro de RemoteEvent (MouseUp)
- Cliente só envia a lista de células + tipo desejado.
- Servidor revalida tudo (saldo, colisões, limites, ownership).
- Nunca confie em dados do cliente.

Fluxo recomendado:
1. Cliente → `BuildRequest:FireServer(cells, tipo)`
2. Servidor valida → se ok aplica e `BuildResult:FireClient(player, true, cells)`
3. Se falhou → `BuildResult:FireClient(player, false, "motivo")`

## 4. Auto-Tiling com Bitmask (4 direções)
Bits: 1 = Norte, 2 = Leste, 4 = Sul, 8 = Oeste.

```lua
local mask = 0
if hasNeighbor(x, z-1) then mask += 1 end -- N
if hasNeighbor(x+1, z) then mask += 2 end -- E
if hasNeighbor(x, z+1) then mask += 4 end -- S
if hasNeighbor(x-1, z) then mask += 8 end -- W

local variant = TILE_VARIANTS[mask] -- tabela de 0 a 15
```
