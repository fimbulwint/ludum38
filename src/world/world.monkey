Strict

Import actors.actor
Import actors.survivor
Import graphics.screen
Import lifecycleaware
Import mojo2
Import world.background
Import world.ground
Import world.levelmarker
Import world.spawners.mobspawner
Import world.spawners.rockspawner
Import world.train
Import world.worldmap
Import world.lifebar
Import actors.collisions
Import drawable

Class World

	Field lifecycleAwares:LifecycleAwares = New LifecycleAwares()
	Field train:Train
	Field mainSurvivor:Survivor
	Field dynamicActors:List<Actor>

	Field mobSpawner:MobSpawner
	Field rockSpawner:RockSpawner
	Field worldMap:WorldMap
	
	Field lifecycleAwaresToAdd:LifecycleAwares = New LifecycleAwares()
	Field lifecycleAwaresToRemove:LifecycleAwares = New LifecycleAwares()
	Field dynamicActorsToRemove:List<Actor> = New List<Actor>()
	
	Method New()
		worldMap = New WorldMap(Self)
		mobSpawner = New MobSpawner(Self)
		rockSpawner = New RockSpawner(Self)

		InitActors()
		InitDrawables()
	End Method
	
	Method InitActors:Void()
		train = New Train()
		mainSurvivor = New Survivor(Self)
		dynamicActors = New List<Actor>()
		
		lifecycleAwares.AddLast(train)
		lifecycleAwares.AddLast(mainSurvivor)
	End Method
	
	Method InitDrawables:Void()
		lifecycleAwares.AddLast(New Ground())
		lifecycleAwares.AddLast(worldMap)
		lifecycleAwares.AddLast(New LevelMarker(worldMap))
		lifecycleAwares.AddLast(New Background())
		lifecycleAwares.AddLast(New Lifebar())
	End Method
	
	Method AddLifecycleAware:Void(aware:LifecycleAware)
		lifecycleAwaresToAdd.AddLast(aware) ' will be considered next Update
	End Method
	
	Method AddDynamicActor:Void(actor:Actor)
		dynamicActors.AddLast(actor) ' will be considered next Update
	End Method

	Method RemoveLifecycleAware:Void(aware:LifecycleAware)
		lifecycleAwaresToRemove.AddLast(aware) ' will be considered next Update
	End Method
	
	Method RemoveDynamicActor:Void(actor:Actor)
		dynamicActorsToRemove.AddLast(actor) ' will be considered next Update
	End Method
	
	Method GetAllActors:List<Actor>()
		Local actors:List<Actor> = New List<Actor>()
		
		actors.AddLast(mainSurvivor)
		For Local actor:Actor = EachIn dynamicActors
			actors.AddLast(actor)
		Next
		
		Return actors
	End Method
		
	Method Update:Void()
		If (lifecycleAwaresToAdd.Count() > 0)
			For Local aware:LifecycleAware = EachIn lifecycleAwaresToAdd
				lifecycleAwares.AddLast(aware)
			End For
			lifecycleAwaresToAdd.Clear()
		End If
		If (lifecycleAwaresToRemove.Count() > 0)
			For Local aware:LifecycleAware = EachIn lifecycleAwaresToRemove
				lifecycleAwares.Remove(aware)
			End For
			lifecycleAwaresToRemove.Clear()
		End If
		If (dynamicActorsToRemove.Count() > 0)
			For Local dynamicActor:Actor = EachIn dynamicActorsToRemove
				dynamicActors.Remove(dynamicActor)
			End For
			dynamicActorsToRemove.Clear()
		End If
		
		For Local aware:LifecycleAware = EachIn lifecycleAwares
			aware.Update(Self)
		Next
		
		mobSpawner.Update(worldMap.level, worldMap.GetCurrentZone().type.id)
		rockSpawner.Update()
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
