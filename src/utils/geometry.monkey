Strict

Import actors.actor

Class Geometry
	
	Function getDirection:Float[] (fromActor:Actor, toActor:Actor)
		Local distanceX:Float = toActor.x - fromActor.x
		Local distanceY:Float = toActor.y - fromActor.y
		Local magnitude:Float = Sqrt(Pow(distanceX, 2) + Pow(distanceY, 2))
		
		Return [distanceX / magnitude, distanceY / magnitude]
	End Function

End Class