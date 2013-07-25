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
import android.view.ViewGroup;
import android.widget.RadioButton;
import android.widget.RadioGroup;
/**
 * A container for radio buttons. Makes them linked. Add instances of 
 * this class to {@link apwidgets.APWidgetContainer}.<br>
 * <br>
 * Add instances of PRadioButtons to this.
 * 
 * @author Rikard Lundstedt
 *
 */
public class APRadioGroup extends APWidget{

	public static final int HORIZONTAL = RadioGroup.HORIZONTAL;
	public static final int VERTICAL = RadioGroup.VERTICAL;
	private Vector<APRadioButton> radioButtons = new Vector<APRadioButton>();
	/**
	 * Creates a new radio group. 
	 * @param x The x position of the radio group.
	 * @param y The y position of the radio group.
	 */
	
	private int orientation = RadioGroup.VERTICAL;
	
	public APRadioGroup(int x, int y) {
		super(x, y, ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
		
	}
	/**
	 * Initializes the radio button. Is called by {@link APWidgetContainer} 
	 * as it is added to it.
	 */
	public void init(PApplet pApplet){
		this.pApplet = pApplet;
		
		if (view == null) {
			view = new RadioGroup(pApplet);
		}
		for (int i = 0;i<radioButtons.size();i++){
			APRadioButton radioButton = radioButtons.elementAt(i);
			radioButton.init(pApplet);
			RadioGroup.LayoutParams layout = new RadioGroup.LayoutParams(radioButton.getWidth(),
					radioButton.getHeight());

			((RadioGroup)view).addView(radioButton.getView(), layout);
			if(radioButton.checked){
				((RadioButton)radioButton.getView()).setChecked(true);
			}
			
		}
		
		((RadioGroup)view).setOrientation(orientation);
		
		super.init(pApplet);
	}
	
	/**Adds a radio button to this radio group. 
	 * <br>
	 * Radio buttons must be added <strong>before</strong> the radio group is added to
	 * the widget container.
	 * @param radioButton
	 */
	public void addRadioButton(APRadioButton radioButton) {
		radioButtons.addElement(radioButton);
	}

	public int getOrientation(){
		return orientation;
	}
	public void setOrientation(int orientation){
		this.orientation = orientation;
		if (initialized) {
			pApplet.runOnUiThread(new Runnable() {
				public void run() {	
					((RadioGroup)view).setOrientation(getOrientation());
				}
			});
		}
	}

}
