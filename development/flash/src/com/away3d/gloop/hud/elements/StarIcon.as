package com.away3d.gloop.hud.elements
{
	import away3d.materials.ColorMaterial;
	
	import flash.display.Sprite;

	public class StarIcon extends Sprite
	{
		public function StarIcon()
		{
			super();
			
			graphics.beginFill(0xffcc00);
			graphics.drawRect(-10, -10, 20, 20);
		}
	}
}