Strict

Import system.time
Import world.world
Import sound.dj
Import actors.railroadRock

Class RockSpawner
	Const MIN_DELAY:Float = 20000
	Const MAX_DELAY:Float = 60000
	
	Field world:World
	Field nextSpawn:Int
	Field hornSound:Int

	Method New(world:World)
		Self.world = world
		nextSpawn = CalculateNextSpawnTime()
		hornSound = nextSpawn - 2000
	End
	
	Method Update:Void()
	    If (Time.instance.actTime >= hornSound)
			Dj.instance.Play(Dj.SFX_TRAIN_HORN)
			' Wanted to assign Int.MAX but doesn't seem to be defined anywhere
			hornSound = nextSpawn * 10
		End If
	
		If (Time.instance.actTime >= nextSpawn)
			SpawnRock()
			nextSpawn = CalculateNextSpawnTime()
			hornSound = nextSpawn - 2000
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