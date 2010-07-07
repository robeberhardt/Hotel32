package com.thelab.hotel32.nav
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.TopNavClip;
	import com.thelab.hotel32.booking.BookingButton;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.views.BasicView;
	import com.thelab.hotel32.views.ViewController;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	
	import org.osflash.signals.Signal;
	
	public class TopNavBar extends MovieClip
	{
		
		private var topNavClip 									: MovieClip;
		private var buttonArray 								: Array;
		private var _selectedButton 							: TopNavButton;
		public var dispatcher 									: Signal;
		private var _active										: Boolean;
		public var bookingButton								: BookingButton;
		
		public function TopNavBar()
		{
			if (stage) { init(); } else { addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); }
		}
		
		private function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
						
			visible = false;
			alpha = 0;
			
			
			
			topNavClip = new TopNavClip();
			x = 302;
			y = 93;
			
			dispatcher = new Signal();
			buttonArray = new Array();
			setupButtons();	
		}
		
		private function setupButtons():void
		{
			while(topNavClip.numChildren > 0)
			{
				
				var navButton:TopNavButton = new TopNavButton(MovieClip(topNavClip.getChildAt(0)));
				addChild(navButton);
				navButton.dispatchClicked.add(handleClicked);
				buttonArray.push(navButton);
			}
		}
		
		public function handleClicked(which:TopNavButton):void
		{
			deselectCurrentButton();
			if (which != null)
			{
				_selectedButton = which;
				which.selected = true;
				dispatcher.dispatch(which);
			}
		}
		
		public function selectButton(which:TopNavButton):void
		{
			deselectCurrentButton();
			if (which != null)
			{
				_selectedButton = which;
				which.selected = true;
			}
		}
		
		private function deselectCurrentButton():void
		{
			if (_selectedButton != null) { _selectedButton.selected = false; }
		}
		
		public function bindViewsToNavButtons():void
		{
			for each (var i:TopNavButton in buttonArray)
			{
				var theView:BasicView = ViewController.getInstance().getViewFromName(i.name);
				i.view = theView;
				theView.boundButton = i;
			}
			show();
		}
		
		public function select(which:TopNavButton):void
		{
			which.selected = true;
		}
		
		public function show():void
		{
			TweenMax.to(this, 1, { autoAlpha: 1 } );
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function set active(value:Boolean):void
		{
			_active = value;
			for each (var i:TopNavButton in buttonArray)
			{
				i.active = _active;
			}
		}
	}
}