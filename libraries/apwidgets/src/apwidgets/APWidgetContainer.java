/**
 * Copyright 2010 Rikard Lundstedt
 * 
 * This file is part of APWidgets.
 * 
 * APWidgets is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * APWidgets is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * You should have received a copy of the GNU General Public License
 * along with APWidgets. If not, see <http://www.gnu.org/licenses/>.
 */

package apwidgets;

import java.util.Vector;

import processing.core.PApplet;
import android.widget.*;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;

public class APWidgetContainer{

	private static void enableGUI(PApplet argPApplet){
		argPApplet.runOnUiThread(new EnableGUITask(argPApplet));
	}
	public APWidgetContainer getThis(){return this;}
//	private int index;
	//private static ScrollView scrollView;
	private int scrollViewID = 983475893;
	
	private MyScrollView scrollView;
	private RelativeLayout layout;
	private PApplet pApplet;
	
	private Vector<View> views = new Vector<View>();
	
	private void createLayout(PApplet pApplet){
		scrollView = new MyScrollView(pApplet);
		scrollView.setFillViewport(true);
		scrollView.setId(scrollViewID);
		pApplet.getWindow().addContentView(
				scrollView,
				new ViewGroup.LayoutParams(
						ViewGroup.LayoutParams.FILL_PARENT,
						ViewGroup.LayoutParams.FILL_PARENT));
		
		layout = new RelativeLayout(pApplet);
		
		scrollView.addView(layout, new ScrollView.LayoutParams(
						ScrollView.LayoutParams.FILL_PARENT,
						ScrollView.LayoutParams.FILL_PARENT)); //WRAP_CONTENT?
	}

	public APWidgetContainer(PApplet pApplet) {
		this.pApplet = pApplet;
	//	enableGUI(pApplet);
		pApplet.runOnUiThread(new Runnable() 
		{
			public void run(){
				if(getPApplet().getWindow().findViewById(scrollViewID)==null){
					createLayout(getPApplet());
				//	System.out.println("create new stuff");
				}else {
					scrollView = (MyScrollView)getPApplet().getWindow().findViewById(scrollViewID);
					layout = (RelativeLayout)scrollView.getChildAt(0);
				//	System.out.println("use existing");
				}
			}
		});
	}

	public void addWidget(APWidget pWidget) {
		pApplet.runOnUiThread(new AddWidgetTask(pWidget));
	}
	
	public void removeWidget(APWidget pWidget) {
		pApplet.runOnUiThread(new RemoveWidgetTask(pWidget));
	}
	
	//remove from layout and destroy instead, to save resources?
	public void hide(){
		pApplet.runOnUiThread(new Runnable()
		{
			public void run(){
			//	layout.setVisibility(View.GONE);
				for(int i = 0;i<views.size();i++){
					views.elementAt(i).setVisibility(View.GONE);
				}
			}
		}); 
	}
	//create new and add instead to save resources?
	public void show(){
		pApplet.runOnUiThread(new Runnable()
		{
			public void run(){
			//	viewFlipper.setDisplayedChild(index);
			//	layout.setVisibility(View.VISIBLE);
				for(int i = 0;i<views.size();i++){
					views.elementAt(i).setVisibility(View.VISIBLE);
				}
			}
		});
	}

	class AddWidgetTask implements Runnable{
		private APWidget pWidget;
		public AddWidgetTask(APWidget pWidget){
			super();
			this.pWidget = pWidget;
		}
		public void run(){
			pWidget.init(pApplet);
			
			RelativeLayout.LayoutParams relLayout = new RelativeLayout.LayoutParams(pWidget.getWidth(),
					pWidget.getHeight());
			relLayout.setMargins(pWidget.getX(), pWidget.getY(), 0, 0);
			relLayout.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
			relLayout.addRule(RelativeLayout.ALIGN_PARENT_TOP);
			
			layout.addView(pWidget.getView(), relLayout);
			
			views.addElement(pWidget.getView());
		}
	}
	
	class RemoveWidgetTask implements Runnable{
		private APWidget pWidget;
		public RemoveWidgetTask(APWidget pWidget){
			super();
			this.pWidget = pWidget;
		}
		public void run(){
			layout.removeView(pWidget.getView());
			views.removeElement(pWidget.getView());
		}
	}
	
	static class EnableGUITask implements Runnable{
		PApplet enableGUITaskPApplet;
		public EnableGUITask(PApplet pApplet){
			enableGUITaskPApplet = pApplet;
		}
		public void run(){
			enableGUITaskPApplet.getWindow().clearFlags(
					WindowManager.LayoutParams.FLAG_FULLSCREEN);
			enableGUITaskPApplet.getWindow().setSoftInputMode(
					WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
		}
	}

	public PApplet getPApplet(){
		return pApplet;
	}
	public void release(){
		pApplet.stop();
	}
}