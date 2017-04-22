Strict


Import mojo2 
Import sound.dj
Import scenes.game
Import scenes.scene
Import system.time


Class Ludum38 Extends App
	Method OnCreate:Int()
		Time.instance.Update()
		Return 0
	End Method

	Method OnClose:Int()
		Return 0
	End Method
	
	Method OnUpdate:Int()
		Time.instance.Update()
		Return 0
	End Method

	Method OnRender:Int()
		Return 0
	End Method
End Class


Function Main:Int()
	New Ludum38()
	Return 0
End Function