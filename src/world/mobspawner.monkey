Strict

Import actors.mutant 
Import system.time
Import world.world

Class MobSpawner
	Const INITIAL_MOBSPAWN_DELAY:Float = 10000
	Const RANDOM_DELAY_FACTOR_MIN:Float = 0.5
	Const RANDOM_DELAY_FACTOR_MAX:Float = 1.5
	
	Field world:World
	Field nextSpawn:Int

	Method New(world:World)
		Self.world = world
		nextSpawn = CalculateNextSpawnTime(1)
	End Method
	
	Method Update:Void(level:Int, zone:String)
		If (Time.instance.actTime >= nextSpawn)
			SpawnMobs(level, zone)
			nextSpawn = CalculateNextSpawnTime(level)
		End If
	End Method
	
	Method CalculateNextSpawnTime:Int(level:Int)
		Local delay:Int = (INITIAL_MOBSPAWN_DELAY - (level * 500)) * Rnd(RANDOM_DELAY_FACTOR_MIN, RANDOM_DELAY_FACTOR_MAX)
		Return Time.instance.actTime + delay
	End Method
	
	Method SpawnMobs:Void(level:Int, zone:String)
		Local groupSize:Int = (1 + level) / 2
		If (Rnd(0.0, 10.0) < 2.5) Then Dj.instance.Play(Dj.SFX_MUTANT_CALL)
		For Local i:Int = 1 To groupSize
			Select (zone)
				Case WorldMap.ZONE_MOUNTAINS
					SpawnMutants(Mutant.TYPE_ROCKY)
				Case WorldMap.ZONE_DESERT
					SpawnMutants(Mutant.TYPE_FIRE)
				Default 
					SpawnMutants(Mutant.TYPE_ROCKY)
			End Select
		End For
	End Method
	
	Method SpawnMutants:Void(type:String)
		Local mutant:Mutant = New Mutant(type, world)
		world.AddLifecycleAware(mutant)
		world.AddDynamicActor(mutant)
	End Method
End Class