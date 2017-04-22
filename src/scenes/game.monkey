Strict

Import scenes.scene
Import world.world

Class Game Implements Scene

	Field world:World = New World()

	Method OnUpdate:Void()
		world.OnUpdate()
	End Method
	
	Method OnRender:Void()
		world.OnRender()
	End Method
	
	Method GetSceneResult:String()
		Return ""
	End Method
	
	Method Finish:Void()
	End Method
	
End Class