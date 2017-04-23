Strict

Import graphics.screen
Import mojo2
Import world.ground
Import world.levelmarker
Import world.train
Import world.worldmap
Import actors.actor
Import actors.survivor
Import actors.darkSurvivor
Import actors.collisions
Import drawable

Class World

	Field lifecycleAwares:LifecycleAwares = New LifecycleAwares()
	Field worldState:WorldState
	Field worldMap:WorldMap
	
	Method New()
		worldState = New WorldState()
		worldMap = New WorldMap(Self)
		InitActors()
		InitDrawables()
	End Method
	
	Method InitActors:Void()
		Local survivor:Survivor = New Survivor()
		Local train:Train = New Train()
		Local ds:DarkSurvivor = New DarkSurvivor()
	
		lifecycleAwares.AddLast(survivor)
		lifecycleAwares.AddLast(train)
		lifecycleAwares.AddLast(ds)
		
		worldState.actors = New List<Actor>()
		worldState.actors.AddLast(survivor)
		worldState.actors.AddLast(train)
		worldState.actors.AddLast(ds)
	End Method
	
	Method InitDrawables:Void()
		lifecycleAwares.AddLast(New Ground())
		lifecycleAwares.AddLast(worldMap)
		lifecycleAwares.AddLast(New LevelMarker(worldMap))
	End Method
	
	Method Update:Void()
		For Local aware:LifecycleAware = EachIn lifecycleAwares
			aware.Update(worldState)
		Next
	End Method
	
	Method Draw:Void(canvas:Canvas)
		lifecycleAwares.Sort()
		For Local aware:LifecycleAware = EachIn lifecycleAwares
			aware.Draw(canvas)
		Next
	End Method
	
End Class

Class LifecycleAwares Extends List<LifecycleAware>
	
	Method Compare:Int(left:LifecycleAware, right:LifecycleAware)
		If (left.z > right.z) Then Return - 1
		If (left.z < right.z) Then Return 1
		Return 0
	End Method
	
End Class

Class WorldState
	Field actors:List<Actor>
End
