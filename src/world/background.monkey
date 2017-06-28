Strict

Import graphics.assets
Import lifecycleaware
Import mojo2

Class Background Extends LifecycleAware

	Field img:Image

	Method New()
		z = 100000.0
		img = Assets.instance.graphics.Get(Assets.GFX_BACKGROUND)
	End Method
	
	Method Update:Void(world:World)
		'empty for now
	End Method

	Method Draw:Void(canvas:Canvas)
		canvas.PushMatrix()
		canvas.SetAlpha(1.0)
		canvas.SetBlendMode(BlendMode.Alpha)
		canvas.SetColor(1.0, 1.0, 1.0)
		canvas.DrawImage(img, 0.0, 0.0)
		canvas.PopMatrix()
	End Method

End Class
