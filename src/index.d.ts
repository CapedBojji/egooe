
import Runtime = require("./Runtime");
import Style = require("./Style");
import create = require("./create");
import button = require("./widgets/button");
import checkbox = require("./widgets/checkbox");
import input = require("./widgets/input");
import window = require("./widgets/window");
import radioButton = require("./widgets/radioButton");
import selectableLabel = require("./widgets/selectableLabel");
import comboBox = require("./widgets/comboBox");
import toggle = require("./widgets/toggle");
import collapsingHeader = require("./widgets/collapsingHeader");
import clickableLabel = require("./widgets/clickableLabel");
import modal = require("./widgets/modal");
import childWindow = require("./widgets/childWindow");
import _table = require("./widgets/table");
import tableRow = require("./widgets/tableRow");
import tableCell = require("./widgets/tableCell");
import slider = require("./widgets/slider");
import dragValue = require("./widgets/dragValue");
import progressBar = require("./widgets/progressBar");
import label = require("./widgets/label");
import heading = require("./widgets/heading");
import separator = require("./widgets/separator");
import row = require("./widgets/row");
import space = require("./widgets/space");
import portal = require("./widgets/portal");
import popup = require("./widgets/popup");
import demoWindow = require("./widgets/demoWindow");

declare const EgooE: typeof Runtime & {
	// Style
	useStyle: typeof Style.get;
	setStyle: typeof Style.set;

	// Utility
	create: typeof create;

	// Widgets
	window: typeof window;
	button: typeof button;
	checkbox: typeof checkbox;
	slider: typeof slider;
	label: typeof label;
	heading: typeof heading;
	separator: typeof separator;
	input: typeof input;
	row: typeof row;
	space: typeof space;
	portal: typeof portal;
	radioButton: typeof radioButton;
	selectableLabel: typeof selectableLabel;
	comboBox: typeof comboBox;
	dragValue: typeof dragValue;
	progressBar: typeof progressBar;
	collapsingHeader: typeof collapsingHeader;
	toggle: typeof toggle;
	clickableLabel: typeof clickableLabel;
	modal: typeof modal;
	popup: typeof popup;
	childWindow: typeof childWindow;
	table: typeof _table;
	tableRow: typeof tableRow;
	tableCell: typeof tableCell;
	demoWindow: typeof demoWindow;
};

export = EgooE;
