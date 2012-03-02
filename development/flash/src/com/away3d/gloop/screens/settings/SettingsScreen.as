package com.away3d.gloop.screens.settings
{
	import com.away3d.gloop.lib.buttons.AboutButton;
	import com.away3d.gloop.lib.buttons.BackButton;
	import com.away3d.gloop.lib.buttons.ClearStateButton;
	import com.away3d.gloop.lib.settings.MusicOffBitmap;
	import com.away3d.gloop.lib.settings.MusicOnBitmap;
	import com.away3d.gloop.lib.settings.SoundOffBitmap;
	import com.away3d.gloop.lib.settings.SoundOnBitmap;
	import com.away3d.gloop.screens.ScreenBase;
	import com.away3d.gloop.screens.ScreenStack;
	import com.away3d.gloop.screens.Screens;
	
	import flash.events.MouseEvent;
	
	public class SettingsScreen extends ScreenBase
	{
		private var _stack : ScreenStack;
		
		private var _aboutBtn : AboutButton;
		private var _clearBtn : ClearStateButton;
		
		private var _soundBtn : ToggleButton;
		private var _musicBtn : ToggleButton;
		
		public function SettingsScreen(stack : ScreenStack)
		{
			super(true, true);
			
			_stack = stack;
		}
		
		
		protected override function initScreen():void
		{
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
			
			_soundBtn = new ToggleButton(new SoundOnBitmap(), new SoundOffBitmap());
			_soundBtn.x = _w/2 - 100;
			_soundBtn.y = 0.4* _h;
			addChild(_soundBtn);
			
			_musicBtn = new ToggleButton(new MusicOnBitmap(), new MusicOffBitmap());
			_musicBtn.x = _w/2 + 100;
			_musicBtn.y = _soundBtn.y;
			addChild(_musicBtn);
			
			_clearBtn = new ClearStateButton();
			_clearBtn.x = _w/2 - _clearBtn.width/2;
			_clearBtn.y = 0.5 * _h;
			addChild(_clearBtn);
			
			/* Add this when necessary
			_aboutBtn = new AboutButton();
			_aboutBtn.x = _w/2 - _aboutBtn.width/2;
			_aboutBtn.y = _clearBtn.y + 140;
			addChild(_aboutBtn);
			*/
		}
		
		
		private function onBackBtnClick(ev : MouseEvent) : void
		{
			_stack.gotoScreen(Screens.START);
		}
	}
}