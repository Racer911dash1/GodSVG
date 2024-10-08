extends PanelContainer

const app_info_json = preload("res://app_info.json")

@onready var version_label: Label = %VersionLabel
@onready var close_button: Button = $VBoxContainer/CloseButton
@onready var translations_list: VBoxContainer = %Translations/List

@onready var project_founder_list: PanelGrid = %ProjectFounder/List
@onready var authors_list: PanelGrid = %Developers/List

@onready var donors_list: PanelGrid = %Donors/List
@onready var golden_donors_list: PanelGrid = %GoldenDonors/List
@onready var diamond_donors_list: PanelGrid = %DiamondDonors/List

func _ready() -> void:
	var app_info: Dictionary = app_info_json.data
	version_label.text = "GodSVG v" + ProjectSettings.get_setting("application/config/version")
	project_founder_list.items = app_info.project_founder_and_manager
	project_founder_list.setup()
	authors_list.items = app_info.authors
	authors_list.setup()
	donors_list.items = app_info.donors
	donors_list.setup()
	golden_donors_list.items = app_info.golden_donors
	golden_donors_list.setup()
	diamond_donors_list.items = app_info.diamond_donors
	diamond_donors_list.setup()
	# There can be multiple translators for a single locale.
	for lang in TranslationServer.get_loaded_locales():
		var credits := TranslationServer.get_translation_object(lang).get_message(
				"translation-credits").split(",", false)
		if credits.is_empty():
			continue
		
		for i in credits.size():
			credits[i] = credits[i].strip_edges()
		
		var label := Label.new()
		label.text = TranslationServer.get_locale_name(lang) + " (%s):" % lang
		translations_list.add_child(label)
		var list := PanelGrid.new()
		list.stylebox = authors_list.stylebox
		list.add_theme_constant_override("h_separation", -1)
		list.add_theme_constant_override("v_separation", -1)
		list.items = credits
		list.setup()
		translations_list.add_child(list)
	
	close_button.pressed.connect(queue_free)
	
	%ProjectFounder/Label.text = TranslationServer.translate("Project Founder and Manager")
	%Developers/Label.text = TranslationServer.translate("Developers")
	%Translations/Label.text = TranslationServer.translate("Translators")
	%Donors/Label.text = TranslationServer.translate("Donors")
	%GoldenDonors/Label.text = TranslationServer.translate("Golden donors")
	%DiamondDonors/Label.text = TranslationServer.translate("Diamond donors")
	$VBoxContainer/TabContainer.set_tab_title(0, TranslationServer.translate("Authors"))
	$VBoxContainer/TabContainer.set_tab_title(1, TranslationServer.translate("Donors"))
	$VBoxContainer/TabContainer.set_tab_title(2, TranslationServer.translate("License"))
	$VBoxContainer/TabContainer.set_tab_title(3, TranslationServer.translate(
			"Third-party licenses"))
	%Components.text = TranslationServer.translate("Godot third-party components")

func _on_components_pressed() -> void:
	OS.shell_open("https://github.com/godotengine/godot/blob/master/COPYRIGHT.txt")
