Strict

Import system.time
Import world.world
Import actors.railroadRock

Class RockSpawner
	Const MIN_DELAY:Float = 20000
	Const MAX_DELAY:Float = 60000
	
	Field world:World
	Field nextSpawn:Int

	Method New(world:World)
		Self.world = world
		nextSpawn = CalculateNextSpawnTime()
	End
	
	Method Update:Void()
		If (Time.instance.actTime >= nextSpawn)
			SpawnRock()
			nextSpawn = CalculateNextSpawnTime()
		End If
	End
	
Private

	Method CalculateNextSpawnTime:Int()
		Return Time.instance.actTime + Rnd(MIN_DELAY, MAX_DELAY)
	End

	Method SpawnRock:Void()
		world.AddLifecycleAware(New RailroadRock())
	End
End