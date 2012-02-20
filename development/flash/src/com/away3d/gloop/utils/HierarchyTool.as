package com.away3d.gloop.utils
{

	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Object3D;
	import away3d.entities.Mesh;
	import away3d.materials.lightpickers.StaticLightPicker;

	public class HierarchyTool
	{
		static public function recursiveApplyLightPicker( object:Object3D, picker:StaticLightPicker ):void {

			if( object is Mesh ) {
				var mesh:Mesh = object as Mesh;
				mesh.material.lightPicker = picker;
			}

			if( object is ObjectContainer3D ) {
				var asContainer:ObjectContainer3D = object as ObjectContainer3D;
				for( var i:uint, len:uint = asContainer.numChildren; i < len; ++i ) {
					recursiveApplyLightPicker( asContainer.getChildAt( i ), picker );
				}
			}

		}
	}
}
