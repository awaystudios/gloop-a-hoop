package com.away3d.gloop.hud.elements
{
	import away3d.materials.ColorMaterial;

	public class HoopInventoryButton extends HUDElement
	{
		public function HoopInventoryButton()
		{
			super();
			
			drawRect(0, 0, 50, 50, 0, 0, 0, 0);
			
			material = new ColorMaterial(0xffcc00);
		}
	}
}