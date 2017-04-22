Strict


Import mojo2 
Import sound.dj
Import scenes.game
Import scenes.scene
Import system.time


Class Ludum38 Extends App
	
	Field currentScene:Scene

	Method OnCreate:Int()
		Time.instance.Update()
		currentScene = New Game()
		Return 0
	End Method

	Method OnClose:Int()
		Return 0
	End Method
	
	Method OnUpdate:Int()
		Time.instance.Update()
		currentScene.OnUpdate()
		Return 0
	End Method

	Method OnRender:Int()
		currentScene.OnRender()
		Return 0
	End Method
End Class


Function Main:Int()
	New Ludum38()
	Return 0
End Function