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
import android.widget.CheckBox;
import android.view.ViewGroup;
/**
 * A Checkbox.Add instances to {@link apwidgets.APWidgetContainer}.<br>
 * <br> 
 * 
 * @author Rikard Lundstedt
 *
 */
public class APCheckBox extends APCompoundButton {
	/** 
	 * Creates a new check box. 
	 * @param x The x position of the check box.
	 * @param y The y position of the check box.
	 * @param text The text on the label of the check box.
	 */
	public APCheckBox(int x, int y, String text) {
		super(x, y, ViewGroup.LayoutParams.WRAP_CONTENT,
				ViewGroup.LayoutParams.WRAP_CONTENT, text);
	}
	/**
	 * Initializes the check box. Is called by {@link APWidgetContainer} 
	 * as it is added to it.
	 * 
	 */
	public void init(PApplet argPApplet) {
		this.pApplet = argPApplet;

		if (view == null) {
			view = new CheckBox(pApplet);
		}

		super.init(pApplet);
	}

}