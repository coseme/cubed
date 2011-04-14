namespace Cubed

import UnityEngine
import System.Linq.Enumerable
import System.Collections.Generic

class BlockTerrain:
  [Property(ChunkWidth)]
  chunkWidth = 10
  [Property(ChunkHeight)]
  chunkHeight = 10
  [Property(ChunkDepth)]
  chunkDepth = 10
  
  [Property(BlockMaterial)]
  blockMaterial as Material
  
  [Property(FloorMaterial)]
  floorMaterial as Material

  [Property(WallMaterial)]
  wallMaterial as Material  

  [Property(BlockWidth)]
  blockWidth = 10f
  
  def GenerateFilledBlockGrid():
    grid = matrix(Block, ChunkWidth, ChunkHeight, ChunkDepth)
    for x in range(ChunkWidth):
      for y in range(ChunkHeight):
        for z in range(ChunkDepth):
          grid[x, y, z] = Block()
    return grid
        
  def GenerateChunks(chunksWide as int, chunksDeep as int):
    for x in range(chunksWide):
      for y in range(chunksDeep):
        GenerateChunk(x, y, null)
  
  def MakeChunk():
    gameObject = GameObject()
    gameObject.AddComponent(MeshFilter)
    gameObject.AddComponent(MeshCollider)
    gameObject.AddComponent(MeshRenderer)
    chunkComponent = gameObject.AddComponent(Chunk)
    chunkComponent.BlockWidth = blockWidth
    chunkComponent.BlockMaterial = blockMaterial
    gameObject.name = "Chunk"
    return gameObject
    
  def GenerateChunk(x as int, y as int, blocks as (Block, 3)):
    blocks = GenerateFilledBlockGrid() if blocks == null
    
    chunk = MakeChunk()
    chunk.transform.position = Vector3(x * chunkWidth * blockWidth, 0f, y * chunkDepth * blockWidth)
    chunk.GetComponent of Chunk().Generate(blocks)
  
  def MakeBarrier():
    return GameObject.CreatePrimitive(PrimitiveType.Cube);
    
  def GenerateBarriers(chunksWide as int, chunksDeep as int):
    GenerateGroundBarriers(chunksWide, chunksDeep)
    GenerateSideBarriers(chunksWide, chunksDeep)
    
  def GenerateSideBarriers(chunksWide as int, chunksDeep as int):
    # south side
    for chunkX in range(chunksWide):
      barrier = MakeBarrier()
      barrier.name = "Wall"
      barrier.renderer.material = wallMaterial
      barrier.transform.localScale = Vector3(chunkWidth * blockWidth, blockWidth * chunkHeight * 2f, blockWidth)
      x = (chunkX * chunkWidth * blockWidth) + ((chunkWidth * blockWidth) / 2f)
      z = -blockWidth / 2f #chunkZ * chunkDepth * blockWidth + ((chunkDepth * blockWidth) / 2f)
      y = blockWidth * chunkHeight
      barrier.transform.position = Vector3(x, y, z)
      
    # north side
    for chunkX in range(chunksWide):
      barrier = MakeBarrier()
      barrier.name = "Wall"
      barrier.renderer.material = wallMaterial
      barrier.transform.localScale = Vector3(chunkWidth * blockWidth, blockWidth * chunkHeight * 2f, blockWidth)
      x = (chunkX * chunkWidth * blockWidth) + ((chunkWidth * blockWidth) / 2f)
      z = (chunkDepth * blockWidth * chunksWide) + (blockWidth / 2f)
      y = blockWidth * chunkHeight
      barrier.transform.position = Vector3(x, y, z)
      
    # west side
    for chunkZ in range(chunksDeep):
      barrier = MakeBarrier()
      barrier.name = "Wall"
      barrier.renderer.material = wallMaterial
      barrier.transform.localScale = Vector3(blockWidth, blockWidth * chunkHeight * 2f, chunkDepth * blockWidth)
      x = -blockWidth / 2f
      z = (chunkDepth * blockWidth * chunkZ) + (chunkDepth * blockWidth / 2f)
      y = blockWidth * chunkHeight
      barrier.transform.position = Vector3(x, y, z)
      
    # west side
    for chunkZ in range(chunksDeep):
      barrier = MakeBarrier()
      barrier.name = "Wall"
      barrier.renderer.material = wallMaterial
      barrier.transform.localScale = Vector3(blockWidth, blockWidth * chunkHeight * 2f, chunkDepth * blockWidth)
      x = (chunkDepth * blockWidth * chunksWide) + (blockWidth / 2f)
      z = (chunkDepth * blockWidth * chunkZ) + (chunkDepth * blockWidth / 2f)
      y = blockWidth * chunkHeight
      barrier.transform.position = Vector3(x, y, z)
        
    
  def GenerateGroundBarriers(chunksWide as int, chunksDeep as int):
    for chunkX in range(chunksWide):
      for chunkZ in range(chunksDeep):
        barrier = MakeBarrier()
        barrier.name = "Ground"
        barrier.renderer.material = floorMaterial
        barrier.transform.localScale = Vector3(chunkWidth * blockWidth, blockWidth, chunkDepth * blockWidth)
        x = (chunkX * chunkWidth * blockWidth) + ((chunkWidth * blockWidth) / 2f)
        z = chunkZ * chunkDepth * blockWidth + ((chunkDepth * blockWidth) / 2f)
        #y = -(chunkHeight * blockWidth / 4f)
        y = -blockWidth / 2f
        barrier.transform.position = Vector3(x, y, z)