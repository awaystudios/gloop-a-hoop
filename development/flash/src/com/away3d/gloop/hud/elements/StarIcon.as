package com.away3d.gloop.hud.elements
{
	import away3d.materials.ColorMaterial;
	import away3d.materials.MaterialBase;

	public class StarIcon extends HUDElement
	{
		public function StarIcon()
		{
			super();
			
			drawRect(-10, -10, 20, 20, 0, 0, 0, 0);
			material = new ColorMaterial(0x00ff00);
		}
	}
}