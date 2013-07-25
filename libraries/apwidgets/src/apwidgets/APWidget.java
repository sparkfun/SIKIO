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

import android.view.View;
import android.view.View.OnClickListener;
import android.widget.RelativeLayout;
import java.lang.reflect.Method;
import java.util.Vector;

import processing.core.PApplet;

public abstract class APWidget implements OnClickListener{

	protected int x;
	protected int y;
	protected int width;
	protected int height;
	protected View view;
	protected PApplet pApplet;
	protected boolean initialized = false;
	protected boolean shouldNotSetOnClickListener = false; //some widgets may break if an onClickListener is set, like TextView whos Done and Next etc. buttons don´t work

	private Vector<OnClickWidgetListener> onClickWidgetListeners = new Vector<OnClickWidgetListener>();
	
	public void addOnClickWidgetListener(OnClickWidgetListener listener){
		onClickWidgetListeners.addElement(listener);
	}
	
	private Method onClickWidgetMethod;

	public View getView() {
		if(!initialized){
			return view;
		}else{
			long time = System.currentTimeMillis();
			while (view == null && System.currentTimeMillis() < time + 1000) {
			}
			return view;
		}
	}

	public APWidget(int x, int y, int width, int height) {
		this.x = x;
		this.y = y;
		this.width = width;
		this.height = height;
	}

	public void onClick(View view) {
		if (onClickWidgetMethod != null) {
			try {
				onClickWidgetMethod.invoke(pApplet, new Object[] { this });
			} catch (Exception e) {
			//	System.err.println("Disabling onWidgetEvent() because of an error.");
				e.printStackTrace();
			//	onClickWidgetMethod = null;
			}
		}
		for(int i = 0;i<onClickWidgetListeners.size();i++){
			onClickWidgetListeners.elementAt(i).onClickWidget(this);
		}
	}

	public void init(PApplet pApplet) {
		this.pApplet = pApplet;
		// for callbacks
		try {
			onClickWidgetMethod = pApplet.getClass().getMethod("onClickWidget",
					new Class[] { APWidget.class });
		} catch (Exception e) {
			// no such method, or an error.. which is fine, just ignore
		}
		if(!shouldNotSetOnClickListener){
			view.setOnClickListener(this);
		}
		initialized = true;
	}
	public void setPosition(int x, int y){
		this.x = x;
		this.y = y;
		if(initialized){
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
				//	RelativeLayout.LayoutParams relLayout = new RelativeLayout.LayoutParams(rWidth,
				//	rHeight);
				//	relLayout.setMargins(rX, rY, 0, 0);
				//	relLayout.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
				//	relLayout.addRule(RelativeLayout.ALIGN_PARENT_TOP);
				//	view.setLayoutParams(relLayout);
					((RelativeLayout.LayoutParams)view.getLayoutParams()).setMargins(getX(), getY(), 0, 0);
					view.requestLayout();
				}
			});
		}
	}
	public void setSize(int width, int height){
		this.width = width;
		this.height = height;
		if(initialized){
			pApplet.runOnUiThread(new Runnable() {
				public void run() {
					RelativeLayout.LayoutParams relLayout = new RelativeLayout.LayoutParams(getWidth(),
					getHeight());
					relLayout.setMargins(x, y, 0, 0);
					relLayout.addRule(RelativeLayout.ALIGN_PARENT_LEFT);
					relLayout.addRule(RelativeLayout.ALIGN_PARENT_TOP);
					view.setLayoutParams(relLayout);
				}
			});
		}
	}
	public int getX(){
		return x;
	}
	public int getY(){
		return y;
	}
	public int getWidth(){
		return width;
	}
	public int getHeight(){
		return height;
	}
	public PApplet getPApplet(){
		return pApplet;
	}
}
