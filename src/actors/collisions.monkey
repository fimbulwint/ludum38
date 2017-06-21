Strict

Import mojo2

Class Collisions

	Global EMPTY_COLLISION_BOX:CollisionBox = New CollisionBox([0.0, 0.0],[0.0, 0.0])

	Function ThereIsCollision:Bool(box1:CollisionBox, box2:CollisionBox)
		If (box1.upperLeft[0] > box2.upperLeft[0] And box1.upperLeft[0] > box2.lowerRight[0]) Then Return False
		If (box1.lowerRight[0] < box2.upperLeft[0] And box1.lowerRight[0] < box2.lowerRight[0]) Then Return False
		If (box1.upperLeft[1] > box2.upperLeft[1] And box1.upperLeft[1] > box2.lowerRight[1]) Then Return False
		If (box1.lowerRight[1] < box2.upperLeft[1] And box1.lowerRight[1] < box2.lowerRight[1]) Then Return False
		Return True
	End Function

End Class

Class CollisionBox
	Field upperLeft:Float[]
	Field lowerRight:Float[]
	
	Method New(upperLeft:Float[], lowerRight:Float[])
		Self.upperLeft = upperLeft
		Self.lowerRight = lowerRight
	End
End Class
