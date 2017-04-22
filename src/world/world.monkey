Strict

Import mojo2
Import actors.actor
Import actors.survivor

Class World

	Field actors: Actors
	
	Method New()
		actors = New Actors()
		actors.AddFirst(New Survivor())
		'TODO: More actors here
		actors.Sort()
	End Method
	
	Method Update:Void()
	End Method
	
	Method Draw:Void(canvas:Canvas)
	End Method
	
End Class

Class Actors Extends List<Actor>
	
	Method Compare:Int(left:Actor, right:Actor)
		If (left.z < right.z) Then Return - 1
		If (left.z > right.z) Then Return 1
		Return 0
	End Method
	
End Class