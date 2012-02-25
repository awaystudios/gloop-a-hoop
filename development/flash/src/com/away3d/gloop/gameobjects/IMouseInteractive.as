package com.away3d.gloop.gameobjects {
	import com.away3d.gloop.gameobjects.components.PhysicsComponent;
	/**
	 * ...
	 * @author Martin Jonasson, m@grapefrukt.com
	 */
	public interface IMouseInteractive {
		
		function get physics():PhysicsComponent;
		
		function onClick(mouseX:Number, mouseY:Number):void;
		function onDragStart(mouseX:Number, mouseY:Number):void;
		function onDragUpdate(mouseX:Number, mouseY:Number):void;
		function onDragEnd(mouseX:Number, mouseY:Number):void;
	}

}