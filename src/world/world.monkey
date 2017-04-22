Strict

Import graphics.screen
Import mojo2
Import world.ground
Import world.train
Import world.worldmap
Import actors.actor
Import actors.survivor
Import drawable

Class World

	Field actors:List<Actor>
	Field drawables:Drawables
	Field worldMap:WorldMap
	
	Method New()
		worldMap = New WorldMap()
		InitActors()
		InitDrawables()
	End Method
	
	Method InitActors:Void()
		actors = New List<Actor>()
		actors.AddLast(New Survivor())
		actors.AddLast(New Train())
	End Method
	
	Method InitDrawables:Void()
		drawables = New Drawables()
		For Local actor:Actor = EachIn actors
			drawables.AddLast(actor)
		Next
		drawables.AddLast(New Ground())
	End Method
	
	Method Update:Void()
		For Local actor:Actor = EachIn actors
			actor.Update()
			'check for collisions and other env data
			actor.CompleteMovement(New WorldState())
		Next
	End Method
	
	Method Draw:Void(canvas:Canvas)
		drawables.Sort()
		For Local drawable:Drawable = EachIn drawables
			drawable.Draw(canvas)
		Next		
	End Method
	
End Class

Class Drawables Extends List<Drawable>
	
	Method Compare:Int(left:Drawable, right:Drawable)
		If (left.z > right.z) Then Return - 1
		If (left.z < right.z) Then Return 1
		Return 0
	End Method
	
End Class

Class WorldState
	
End