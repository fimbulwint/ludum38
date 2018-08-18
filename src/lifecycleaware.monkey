Strict

Import mojo2
Import world.world

Class LifecycleAware Abstract

	Field affectedByWorldEffects:Bool = True
	Field z:Float

	Method Draw:Void(canvas:Canvas) Abstract
	Method Update:Void(world:World) Abstract
	
End Class