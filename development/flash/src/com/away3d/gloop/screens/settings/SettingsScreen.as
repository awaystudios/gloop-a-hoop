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
	import com.away3d.gloop.sound.MusicManager;
	import com.away3d.gloop.sound.SoundManager;
	import com.away3d.gloop.sound.Sounds;
	import com.away3d.gloop.utils.StateSaveManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class SettingsScreen extends ScreenBase
	{
		private var _stack : ScreenStack;
		private var _stateMgr : StateSaveManager;
		
		private var _aboutBtn : AboutButton;
		private var _clearBtn : ClearStateButton;
		
		private var _soundBtn : ToggleButton;
		private var _musicBtn : ToggleButton;
		
		public function SettingsScreen(stack : ScreenStack, stateMgr : StateSaveManager)
		{
			super(true, true);
			
			_stack = stack;
			_stateMgr = stateMgr;
		}
		
		
		protected override function initScreen():void
		{
			_backBtn.addEventListener(MouseEvent.CLICK, onBackBtnClick);
			
			_soundBtn = new ToggleButton(new SoundOnBitmap(), new SoundOffBitmap());
			_soundBtn.x = _w/2 - 100;
			_soundBtn.y = 0.4* _h;
			_soundBtn.toggledOn = true;
			_soundBtn.addEventListener(Event.CHANGE, onSoundToggleChange);
			addChild(_soundBtn);
			
			_musicBtn = new ToggleButton(new MusicOnBitmap(), new MusicOffBitmap());
			_musicBtn.x = _w/2 + 100;
			_musicBtn.y = _soundBtn.y;
			_musicBtn.toggledOn = true;
			_musicBtn.addEventListener(Event.CHANGE, onMusicToggleChange);
			addChild(_musicBtn);
			
			_clearBtn = new ClearStateButton();
			_clearBtn.x = _w/2 - _clearBtn.width/2;
			_clearBtn.y = 0.5 * _h;
			_clearBtn.addEventListener(MouseEvent.CLICK, onClearBtnClick);
			addChild(_clearBtn);
			
			/* Add this when necessary
			_aboutBtn = new AboutButton();
			_aboutBtn.x = _w/2 - _aboutBtn.width/2;
			_aboutBtn.y = _clearBtn.y + 140;
			addChild(_aboutBtn);
			*/
		}
		
		
		private function onMusicToggleChange(ev : Event) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			MusicManager.enabled = _musicBtn.toggledOn;
		}
		
		
		private function onSoundToggleChange(ev : Event) : void
		{
			SoundManager.enabled = true;
			SoundManager.play(Sounds.MENU_BUTTON);

			SoundManager.enabled = _soundBtn.toggledOn;
		}
		
		
		private function onClearBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stateMgr.clearState();
		}
		
		
		private function onBackBtnClick(ev : MouseEvent) : void
		{
			SoundManager.play(Sounds.MENU_BUTTON);
			_stack.gotoScreen(Screens.START);
		}
	}
}