Strict

Import actors.actor
Import actors.survivor
Import graphics.screen
Import lifecycleaware
Import mojo2
Import world.ground
Import world.levelmarker
Import world.mobspawner
Import world.train
Import world.worldmap
Import actors.collisions
Import drawable

Class World

	Field lifecycleAwares:LifecycleAwares = New LifecycleAwares()
	Field worldState:WorldState
	Field mobSpawner:MobSpawner
	Field worldMap:WorldMap
	
	Field lifecycleAwaresToAdd:LifecycleAwares = New LifecycleAwares()
	
	Method New()
		worldState = New WorldState()
		worldMap = New WorldMap(Self)
		mobSpawner = New MobSpawner(Self)
		InitActors()
		InitDrawables()
	End Method
	
	Method InitActors:Void()
		Local survivor:Survivor = New Survivor()
		Local train:Train = New Train()
	
		lifecycleAwares.AddLast(survivor)
		lifecycleAwares.AddLast(train)
		
		worldState.mainActors = New List<Actor>()
		worldState.dynamicActors = New List<Actor>()
		worldState.mainActors.AddLast(survivor)
		worldState.mainActors.AddLast(train)
	End Method
	
	Method InitDrawables:Void()
		lifecycleAwares.AddLast(New Ground())
		lifecycleAwares.AddLast(worldMap)
		lifecycleAwares.AddLast(New LevelMarker(worldMap))
	End Method
	
	Method AddLifecycleAware:Void(aware:LifecycleAware)
		lifecycleAwaresToAdd.AddLast(aware) ' will be considered next Update
	End Method
	
	Method AddDynamicActor:Void(actor:Actor)
		worldState.dynamicActors.AddLast(actor) ' will be considered next Update
	End Method
	
	Method Update:Void()
		If (lifecycleAwaresToAdd.Count() > 0)
			For Local aware:LifecycleAware = EachIn lifecycleAwaresToAdd
				lifecycleAwares.AddLast(aware)
			End For
			lifecycleAwaresToAdd.Clear()
		End If
		
		For Local aware:LifecycleAware = EachIn lifecycleAwares
			aware.Update(worldState)
		Next
		
		mobSpawner.Update()
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
	Field mainActors:List<Actor>
	Field dynamicActors:List<Actor>
End
