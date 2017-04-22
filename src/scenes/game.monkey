Strict

Import mojo2
Import scenes.scene
Import world.world

Class Game Implements Scene

	Field world:World = New World()

	Method OnUpdate:Void()
		world.OnUpdate()
	End Method
	
	Method OnRender:Void(canvas:Canvas)
		world.OnRender(canvas)
	End Method
	
	Method GetSceneResult:String()
		Return Scene.STILL_CURRENT_SCENE
	End Method
	
	Method Finish:Void()
	End Method
	
End Class