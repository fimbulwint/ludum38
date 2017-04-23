Strict

Import actors.mutant 
Import world.world

Class MobSpawner
	Field world:World

	Method New(world:World)
		Self.world = world
	End Method
	
	Method Update:Void()
		If (world <> Null) ' trick
			world.AddLifecycleAware(New Mutant(Mutant.TYPE_ROCKY, world))
			world = Null
		End If
	End Method
End Class