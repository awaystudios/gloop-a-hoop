package com.away3d.gloop.hud
{
	import away3d.core.base.data.Vertex;
	
	import com.away3d.gloop.hud.elements.HUDElement;
	import com.away3d.gloop.hud.elements.HoopInventoryButton;

	public class HUD extends HUDElement
	{
		public function HUD()
		{
			var btn : HoopInventoryButton;
			
			btn = new HoopInventoryButton();
			addChild(btn);
		}
	}
}