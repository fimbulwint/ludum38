Strict

< < < < < < < HEAD
Import graphics.screen
Import mojo2
Import world.ground
Import world.train
Import actors.actor
Import actors.survivor


Class World
	Field ground:Ground
	Field train:Train

	Field actors:Actors
	
	Method New()
		ground = New Ground()
		train = New Train()
		actors = New Actors()
		actors.AddLast(New Survivor())
		actors.AddLast(New Train())
		'TODO: More actors here
		actors.Sort()
	End Method
	
	Method Update:Void()
		ground.Update()
		train.Update()
	End Method
	
	Method Draw:Void(canvas:Canvas)
		ground.Draw(canvas)
		train.Draw(canvas)
	End Method
	
End Class

Class Actors Extends List<Actor>
	
	Method Compare:Int(left:Actor, right:Actor)
		If (left.z < right.z) Then Return - 1
		If (left.z > right.z) Then Return 1
		Return 0
	End Method
	
End Class