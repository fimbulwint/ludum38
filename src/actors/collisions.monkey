Strict

Import mojo2

Class Collisions

	Global EMPTY_HIT_BOX:HitBox = New HitBox([0.0, 0.0],[0.0, 0.0])

	Function ThereIsCollision:Bool(box1:HitBox, box2:HitBox)
		If (box1.upperLeft[0] > box2.upperLeft[0] And box1.upperLeft[0] > box2.lowerRight[0]) Then Return False
		If (box1.lowerRight[0] < box2.upperLeft[0] And box1.lowerRight[0] < box2.lowerRight[0]) Then Return False
		If (box1.upperLeft[1] > box2.upperLeft[1] And box1.upperLeft[1] > box2.lowerRight[1]) Then Return False
		If (box1.lowerRight[1] < box2.upperLeft[1] And box1.lowerRight[1] < box2.lowerRight[1]) Then Return False
		Return True
	End Function

End Class

Class HitBox
	Field upperLeft:Float[]
	Field lowerRight:Float[]
	
	Method New(upperLeft:Float[], lowerRight:Float[])
		Self.upperLeft = upperLeft
		Self.lowerRight = lowerRight
	End
End Class
