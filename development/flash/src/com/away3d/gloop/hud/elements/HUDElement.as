package com.away3d.gloop.hud.elements
{
	import away3d.core.base.Geometry;
	import away3d.core.base.SubGeometry;
	import away3d.core.base.SubMesh;
	import away3d.entities.Mesh;
	import away3d.materials.MaterialBase;
	
	public class HUDElement extends Mesh
	{
		private var _verts : Vector.<Number>;
		private var _inds : Vector.<uint>;
		private var _uvs : Vector.<Number>;
		
		public function HUDElement()
		{
			super()
			
			_verts = new Vector.<Number>();
			_inds = new Vector.<uint>();
			_uvs = new Vector.<Number>();
		}
		
		
		protected function drawRect(px : Number, py : Number, w : Number, h : Number, u : Number, v : Number, uw : Number, vh : Number) : void
		{
			var idx : uint;
			var sub : SubGeometry;
			
			idx = _verts.length / 3;
			
			_verts.push(
				px, py, 0,
				px+w, py, 0,
				px+w, py-h, 0,
				px, py-h, 0);
			
			_inds.push(
				idx+0, idx+1, idx+2,
				idx+0, idx+2, idx+3);
			
			_uvs.push(
				u, v,
				u+uw, v,
				u+uw, v-vh,
				u, v-vh);
			
			if (_geometry.subGeometries.length == 0)
				_geometry.addSubGeometry(new SubGeometry());
			
			sub = _geometry.subGeometries[0];
			sub.updateVertexData(_verts);
			sub.updateIndexData(_inds);
			sub.updateUVData(_uvs);
		}
	}
}