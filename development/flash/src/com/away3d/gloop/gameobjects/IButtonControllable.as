package com.away3d.gloop.gameobjects
{
	public interface IButtonControllable
	{
		function get buttonGroup() : uint;
		function toggleOn() : void;
		function toggleOff() : void;
	}
}