Strict

Import graphics.screen
Import mojo2
Import world.ground
Import world.train
Import actors.actor
Import actors.survivor


Class World

	Field actors:Actors
	
	Method New()
		actors = New Actors()
		actors.AddLast(New Survivor())
		actors.AddLast(New Train())
		actors.AddLast(New Ground())
		actors.Sort()
	End Method
	
	Method Update:Void()
		For Local actor:Actor = EachIn actors
			actor.Update()
		Next
	End Method
	
	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(0.0, 0.6, 0.0)
		canvas.DrawRect(0.0, Screen.GroundHeight, Screen.Width, Screen.Height - Screen.GroundHeight)
		
		For Local actor:Actor = EachIn actors
			actor.Draw(canvas)
		Next
		
		canvas.PopMatrix()
	End Method
	
End Class

Class Actors Extends List<Actor>
	
	Method Compare:Int(left:Actor, right:Actor)
		If (left.z < right.z) Then Return - 1
		If (left.z > right.z) Then Return 1
		Return 0
	End Method
	
End Class