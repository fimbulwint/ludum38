Strict

Import graphics.screen
Import mojo2
Import world.ground
Import world.train
Import world.worldmap
Import actors.actor
Import actors.survivor


Class World

	Field actors:Actors
	Field worldMap:WorldMap
	
	Method New()
		worldMap = New WorldMap()
		actors = New Actors()
		actors.AddLast(New Survivor())
		actors.AddLast(New Train())
		actors.AddLast(New Ground())
	End Method
	
	Method Update:Void()
		For Local actor:Actor = EachIn actors
			actor.Update()
			'check for collisions and other env data
			actor.CompleteMovement(New WorldState())
		Next
	End Method
	
	Method Draw:Void(canvas:Canvas)
		actors.Sort()
		For Local actor:Actor = EachIn actors
			actor.Draw(canvas)
		Next		
	End Method
	
End Class

Class Actors Extends List<Actor>
	
	Method Compare:Int(left:Actor, right:Actor)
		If (left.z > right.z) Then Return - 1
		If (left.z < right.z) Then Return 1
		Return 0
	End Method
	
End Class

Class WorldState
	
End