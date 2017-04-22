Strict


Import mojo2 
Import sound.dj
Import scenes.game
Import scenes.scene
Import system.time
Import world.world



Class Ludum38 Extends App
	
	Field currentScene:Scene

	Method OnCreate:Int()
		Time.instance.Update()
		currentScene = New Game()
		Return 0
	End Method

	Method OnClose:Int()
		currentScene.Finish()
		currentScene = Null
		Return 0
	End Method
	
	Method OnUpdate:Int()
		Time.instance.Update()
		
		Local sceneResult:String = currentScene.GetSceneResult()
		Select (sceneResult)
			Case ""
			Case Scene.RESULT_END
				currentScene.Finish()
				'for now nothing else
		End Select
		
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