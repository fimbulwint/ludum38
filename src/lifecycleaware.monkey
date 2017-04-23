Strict

Import mojo2
Import world.world

Class LifecycleAware Abstract

	Field z:Float

	Method Draw:Void(canvas:Canvas) Abstract
	Method Update:Void(worldState:WorldState) Abstract
	
End Class