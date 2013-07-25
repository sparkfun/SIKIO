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

import processing.core.PApplet;
import android.widget.CompoundButton;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.view.ViewGroup;
/**
 * A radio button. <br>
 * <br>
 * PRadioButtons are added to a {@link apwidgets.APRadioGroup}. 
 * The PRadioGroup is then added to the {@link apwidgets.APWidgetContainer}.<br>
 * <br>
 * Do not add radio buttons to the radio group after 
 * the radio group is added to the widget container.
 * 
 * Not working yet. Don't know how to check if chosen.
 * 
 * @author Rikard Lundstedt
 *
 */
public class APRadioButton extends APButton {
	
	protected boolean checked = false;
	
	/**
	 * Creates a radio button. 
	 * @param text The text on the label of the radio button.
	 */
	public APRadioButton(String text) {
		super(0, 0, ViewGroup.LayoutParams.WRAP_CONTENT,
				ViewGroup.LayoutParams.WRAP_CONTENT, text);
	}
	/**
	 * Initializes the radio button. Is called by {@link APRadioGroup} 
	 * as it is added to it.
	 */
	public void init(PApplet pApplet) {
		this.pApplet = pApplet;

		if (view == null) {
			view = new RadioButton(pApplet);
		}
		super.init(pApplet);
	}
	public void setChecked(boolean checked){
		this.checked = checked;
		if(initialized){
			if( ((RadioButton)view).getParent() !=null && ((RadioButton)view).getParent() instanceof RadioGroup){
				if (checked) {
					pApplet.runOnUiThread(new Runnable() {
						public void run() {
							((RadioButton) view).setChecked(true);
						}
					});
				} else {
					pApplet.runOnUiThread(new Runnable() {
						public void run() {
							((RadioButton) view).setChecked(false);
						}
					});
				}
			}
		}
	}
	public boolean isChecked() {
		if (!initialized) {
			return checked;
		} else {
			return ((RadioButton) view).isChecked();
		}
	}
}