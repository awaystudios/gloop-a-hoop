/**
 * Created by Li using IntelliJ IDEA.
 * Date: 2/20/12
 */
package com.away3d.gloop.camera
{

	import away3d.cameras.Camera3D;

	import flash.display.DisplayObject;

	public interface ICameraController
	{
		function set camera( value:Camera3D ):void;
		function set context( value:DisplayObject ):void
		function dispose():void;
		function update():void;
	}
}
