Strict

Import mojo2

Interface Scene

	Const STILL_CURRENT_SCENE:String = ""
	Const RESULT_END:String = "RESULT_END"

	Method Update:Void()
	Method Draw:Void(canvas:Canvas)
	
	Method GetSceneResult:String()
	
	Method Finish:Void()
End Interface
