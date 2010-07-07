package com.thelab.hotel32.views.rooms
{
	import com.greensock.TweenMax;
	import com.thelab.hotel32.assets.AssetController;
	import com.thelab.hotel32.common.BackgroundLoader;
	import com.thelab.hotel32.common.PageButton;
	import com.thelab.hotel32.common.TabPanel;
	import com.thelab.hotel32.common.Tab;
	import com.thelab.hotel32.helpers.Logger;
	import com.thelab.hotel32.views.BasicView;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class RoomsView extends BasicView
	{
		private var boxArray								: Array;
		private var boxgrid									: RoomsBoxGrid;
		private var tabPanel								: TabPanel;
		private var bgLoader								: BackgroundLoader;
				
		public function RoomsView(name:String=null)
		{
			super(name);
		}	
		
		override public function setup():void
		{
			assetsLoaded.addOnce(onAssetsLoaded);
			loadAssets();
		}
		
		private function onAssetsLoaded():void
		{
			bgLoader = new BackgroundLoader(pageXML);
			addChild(bgLoader);
			bgLoader.transitionMiddle.add( function() { tabPanel.refreshContent(); } );
			makeBoxGrid();
		}
				
		/* ----------------------------------------------------------------------------------------
		* 
		*            							BOX GRID STUFF
		*
		*/
		
		private function makeBoxGrid():void
		{

			boxgrid = new RoomsBoxGrid(2, 2, 498, 229, 10, 10);
			boxgrid.x = 86;
			boxgrid.y = 10;
			boxgrid.alpha = 0;
			boxgrid.visible = false;
			addChild(boxgrid);
						
			boxArray = new Array();
			for (var i:int = 0; i < pageXML..boxes..box.length(); i++)
			{
				var boxData : XML = pageXML..boxes.box[i];
				var myBox:RoomBox = new RoomBox(boxData.@id.toString());
				myBox.index = i;
				
				myBox.mainAsset = queue.getContent(boxData.images.@thumb);
				myBox.overAsset = queue.getContent(boxData.images.@over);
				myBox.title = boxData.title.toString();
				
				myBox.clickedSender.add(onBoxClicked);
				
				boxArray.push(myBox);
				boxgrid.addToGrid(myBox);				
			}
			
			transitionStarted.add(onTransStart);
			transitionFinished.add(onTransFinish);
			
			makeTabBox();
			
		}
		
		private function onBoxClicked(which:RoomBox):void
		{
			Logger.log("YOU CLICKED ON " + which);	
			boxgrid.hide();
			tabPanel.selectByName(which.name);
			tabPanel.show();
			bgLoader.show();
		}
		
		private function openBox(id:String):void
		{
			for (var i:uint = 0; i < boxArray.length; i++)
			{
				if (boxArray[i].name == id)
				{
					boxArray[i].open();
				}
			}
		}
		
		private function boxesActive(val:Boolean):void
		{
			Logger.log("setting all boxes to " + val);
			for each (var b:RoomBox in boxArray)
			{
				b.active = val;
			}
		}
		
		/* ----------------------------------------------------------------------------------------
		* 
		*            							TAB CONTROL STUFF
		*
		*/
		
		private function makeTabBox():void
		{
			tabPanel = new TabPanel("roomsTabbedBox", pageXML);
			addChild(tabPanel);
			
			tabPanel.paginatorReady.addOnce( function()
			{
				tabPanel.paginator.selectedSender.add(onPageSelected);
			});
			
			tabPanel.thumbSender.add(onThumbClicked);
						
			tabPanel.visible = false;
			
			boxgrid.show();
			
			sendReady();
		}
		
		private function onThumbClicked():void
		{
			tabPanel.hide();
			bgLoader.hide();
			TweenMax.delayedCall(.25, function() { boxgrid.show(); } );
		}
		
		private function onPageSelected(which:PageButton):void
		{
			var selectedTabName:String = TabPanel(which.parent.parent).selectedTab.name;
			Logger.log("selectedTabName: " + selectedTabName);
			
			var theURL:String = pageXML..tab.(@id == selectedTabName).images.image[which.index-1].@id.toString();
			
			bgLoader.load(selectedTabName, theURL);
			
			//tabBox.hideCopy();
		}
		
		/* ----------------------------------------------------------------------------------------
		* 
		*            						VIEW TRANSITIONS
		*
		*/
		
		private function onTransStart(whichDirection:String):void
		{
			switch (whichDirection)
			{
				case TRANSITION_IN :
					
					break;
				
				case TRANSITION_OUT :
					boxesActive(false);
					break;
			}
		}
		
		private function onTransFinish(whichDirection:String):void
		{
			switch (whichDirection)
			{
				case TRANSITION_IN :
					boxesActive(true);
					if (deepLink != null) { openBox(deepLink); }
					break;
				
				case TRANSITION_OUT :
					
					break;
			}
		}
	}
}